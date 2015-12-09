require 'fastimage'

module DirModel
  module Export
    extend ActiveSupport::Concern

    included do
      include Files
    end

    attr_reader :source_model, :context

    # @param [Model] source_model object to export to files
    # @param [Hash]  context
    def initialize(source_model, context={})
      @source_model = source_model
      @context      = OpenStruct.new(context)
      @root_path    = Dir.mktmpdir
    end

    def path
      generate unless generated?
      @root_path
    end

    private

    def generated?
      !!@generated
    end

    def generate
      cleanup if generated?

      self.class.file_names.each do |file_name|
        options = self.class.options(file_name)

        next if self.send("#{file_name}_skip?")

        dir_path  = get_value_of(options[:path])
        file_path = File.join(dir_path, get_value_of(options[:name]))

        mkdir { File.join(@root_path, dir_path) }

        file_path = ensure_extension(file_path, file_name)

        File.open(File.join(@root_path, file_path), 'wb') {|f| f.write(self.public_send(file_name).read) }
      end
    ensure
      @generated = true
    end

    def ensure_extension(file_path, file_method_name)
      return file_path if File.extname(file_path).present? # Return if extension was provided in name: attribute, i.e name: 'image.png'

      file_path_with_extension = file_path

      # Looking into <file_name>_extension method
      ext = self.public_send("#{file_method_name}_extension")
      ext ||= FastImage.type(self.public_send(file_method_name))
      unless ext
        # You have to provide an extension i.e name: 'file.json
        raise StandardError.new("options :name should provide an extension")
      end

      file_path_with_extension = file_path + '.' + ext.to_s
    end

    def get_value_of(string_or_proc)
      return string_or_proc if string_or_proc.is_a?(String)
      instance_exec(&string_or_proc)
    end

    def cleanup
      FileUtils.remove_entry @root_path
      @generated = false
    end
  end
end
