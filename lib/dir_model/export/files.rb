module DirModel
  module Export
    module Files
      extend ActiveSupport::Concern

      included do
        self.file_names.each { |*args| define_skip_method(*args) }
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

        protected

        def file(file_name, options={})
          super
          define_skip_method(file_name)
        end
      end

    end
  end
end
