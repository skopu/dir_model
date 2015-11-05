require 'active_support/hash_with_indifferent_access'

module DirModel
  module Export
    class AggregateDir
      include Utils

      attr_reader :export_dir_model_class, :context, :paths, :copy_path

      # @param [Export] export_model export model class
      def initialize(export_dir_model_class, context={})
        @export_dir_model_class = export_dir_model_class
        @context                = context.to_h.symbolize_keys
        @copy_path              = Dir.mktmpdir
      end

      # Add a row_model to the
      # @param [] source_model the source model of the export file model
      # @param [Hash] context the extra context given to the instance of the file model
      def append_model(source_model, context={})
        export_dir_model_class.new(source_model, context.reverse_merge(self.context)).paths.each do |file_path|
          add_path(file_path)
        end
      end
      alias_method :<<, :append_model

      def generate
        @paths ||= []
        # need #generated? method
        yield self
      end

      private

      def add_path(source_path)
        FileUtils.cp_r source_path, @copy_path
      end

    end
  end
end
