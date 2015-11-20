module DirModel
  module Model
    extend ActiveSupport::Concern

    included do
      include Utils
      include InheritedClassVar
      inherited_class_hash :files
    end

    module ClassMethods

      # @return [Array<Symbol>] file names
      def file_names
        files.keys
      end

      protected

      def file(file_name, options={})
        merge_files(file_name.to_sym => options)
      end
    end
  end
end
