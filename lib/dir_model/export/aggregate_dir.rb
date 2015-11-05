require 'active_support/hash_with_indifferent_access'

module DirModel
  module Export
    class AggregateDir

      attr_reader :export_dir_model_class, :context, :paths

      # @param [Export] export_model export model class
      def initialize(export_dir_model_class, context={})
        @export_dir_model_class = export_dir_model_class
        @context = context.to_h #.symbolize_keys
      end

      # Add a row_model to the
      # @param [] source_model the source model of the export file model
      # @param [Hash] context the extra context given to the instance of the file model
      def append_model(source_model, context={})
        @paths << export_dir_model_class.new(source_model, context.reverse_merge(self.context)).path
      end
      alias_method :<<, :append_model

      def generate
        @paths ||= []
        # need #generated? method
        yield self
      end

      # # not the real implementation
      # # please replace: https://github.com/FinalCAD/dir_model/blob/4dfa789fcd54b52cfd44de4d6bc80f68dcbe202c/lib/dir_model/core_ext/zip_dir/zipper.rb#L6-L6
      # #
      # # and do something like this: https://github.com/FinalCAD/zip_dir/blob/16a915db065a96624f3f357b1be31c80afc1e4bf/lib/zip_dir/zipper.rb#L10-L10
      # #
      # # so we don't need to think about paths
      # def path
      #   @paths.first
      # end
    end
  end
end
