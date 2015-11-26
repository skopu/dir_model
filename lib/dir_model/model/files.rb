module DirModel
  module Model
    module Files
      extend ActiveSupport::Concern

      included do
        include InheritedClassVar
        inherited_class_hash :files
      end

      module ClassMethods
        # @return [Array<Symbol>] file names for the row model
        def file_names
          files.keys
        end

        # @param [Symbol] file_name name of file to find option
        # @return [Hash] options for the file_name
        def options(file_name)
          files[file_name]
        end

        # @param [Symbol] file_name name of file to find index
        # @return [Integer] index of the file_name
        def index(file_name)
          file_names.index file_name
        end

        protected

        def file(file_name, options={})
          check_attributes!(options)
          merge_files(file_name.to_sym => with_default_extensions(options))
        end

        private

        def check_attributes!(options)
          options[:type] ||= :image
          if options[:type] != :image and options[:extension].blank?
            raise StandardError.new(
              "Expected extension should be define with 'type: :#{options[:type]}', like 'extension: :json'"
            )
          end
        end

        def with_default_extensions(options)
          options[:extensions] ||= ['*']
          options
        end

      end
    end
  end
end
