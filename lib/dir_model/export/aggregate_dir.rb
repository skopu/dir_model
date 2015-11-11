require 'active_support/hash_with_indifferent_access'

module DirModel
  module Export
    class AggregateDir
      include Utils

      attr_reader :export_dir_model_class, :context

      # @param [Export] export_model export model class
      def initialize(export_dir_model_class, context={})
        @export_dir_model_class = export_dir_model_class
        @context                = context.to_h.symbolize_keys
        @dir_path               = Dir.mktmpdir
      end

      # Add a row_model to the
      # @param [] source_model the source model of the export file model
      # @param [Hash] context the extra context given to the instance of the file model
      def append_model(source_model, context={})
        FileUtils.cp_r export_dir_model_class.new(source_model, context.reverse_merge(self.context)).path,
          @dir_path
      end
      alias_method :<<, :append_model

      def generate
        yield self
        self
      end

      def full_path(file_path)
        File.join(@dir_path, Dir.clean_entries(@dir_path).first, file_path)
      end

    end
  end
end
