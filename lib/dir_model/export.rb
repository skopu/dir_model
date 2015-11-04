module DirModel
  module Export

    attr_reader :source_model, :context

    # @param [Model] source_model object to export to files
    # @param [Hash]  context
    def initialize(source_model, context={})
      @source_model = source_model
      @context      = OpenStruct.new(context)
    end

    def path
      generate unless generated?
      @temp_path
    end

    private

    def generated?
      !!@generated
    end

    def generate
      cleanup if generated?
      @temp_path = Dir.mktmpdir

      @pwd = [@temp_path]
      _generate
    ensure
      @generated = true
    end

    def cleanup
      FileUtils.remove_entry_secure @temp_path
      @generated = false
    end

    def _generate
      self.class.files.each do |file_name, options|
        dir_path = File.join(*give_real_path(options[:path]))
        FileUtils.mkdir_p(dir_path)
        File.open(File.join(dir_path, self.public_send(options[:name])), 'wb') do |f|
          f.write(self.public_send(file_name).read)
        end
      end
    end

    def give_real_path(path)
      path.scan(/{{(?<value>[^{}]*)}}/).map do |dir_name|
        self.public_send(dir_name.first)
      end
    end
  end
end
