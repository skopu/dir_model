module DirModel
  module Export
    module Files
      extend ActiveSupport::Concern

      included do
        define_file_method(self.file_name)
        define_skip_method(self.file_name)
        define_extension_method(self.file_name)
      end

      module ClassMethods

        # Safe to override
        #
        # Define default skip method for a file
        # @param file_name [Symbol] the file: name
        def define_skip_method(file_name)
          define_method(:skip?) do
            _file = self.public_send(file_name)

            return true if _file.nil?
            if _file.respond_to?(:exists?) # Carrierwave with remote file
              return true unless _file.exists?
            else
              if _file.respond_to?(:path) # Locale file
                return true unless File.exists?(_file.path)
              end
            end
            return true unless _file.respond_to?(:read)

            false
          end
        end

        # Safe to override
        #
        # Define default file method for defined file
        # @param file_name [Symbol] the file: name
        def define_file_method(file_name)
          define_method(file_name) do
            file = file_or_uploader = source_model.public_send(file_name)
            if file_or_uploader.respond_to?(:file) # Carrierwave Uploader
              file = file_or_uploader.file
            end
            file
          end
        end

        # Safe to override
        #
        # Define default extension method for defined file
        # @param file_name [Symbol] the file: name
        def define_extension_method(file_name)
          define_method("#{file_name}_extension") do
            return unless self.public_send(file_name).respond_to?(:extension)
            self.public_send(file_name).extension # Carrierwave Uploader
          end
        end

        protected

        def file(file_name, options={})
          super

          define_file_method(file_name)
          define_skip_method(file_name)
          define_extension_method(file_name)
        end
      end

    end
  end
end
