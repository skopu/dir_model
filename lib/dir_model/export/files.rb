module DirModel
  module Export
    module Files
      extend ActiveSupport::Concern

      included do
        self.file_names.each do |*args|
          define_skip_method(*args)
          define_file_method(*args)
        end
      end

      module ClassMethods

        # Safe to override
        #
        # Define default skip method for a file
        # @param file_name [Symbol] the file: name
        def define_skip_method(file_name)
          define_method("#{file_name}_skip?") do
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

        protected

        def file(file_name, options={})
          super
          define_skip_method(file_name)
          define_file_method(file_name)
        end
      end

    end
  end
end
