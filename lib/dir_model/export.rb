module DirModel
  module Export

    attr_reader :source_model, :context

    # @param [Model] source_model object to export to files
    # @param [Hash]  context
    def initialize(source_model, context={})
      @source_model = source_model
      @context      = OpenStruct.new(context)
      @paths        = []
    end

    def path
      generate unless generated?
      @file_path
    end

    private

    def generated?
      !!@generated
    end

    def generate
      cleanup if generated?
      tmp_dir_path = Dir.mktmpdir

      self.class.files.each do |file_name, options|
        dir_path  = File.join(*path_from_template_string(options[:path]))
        file_path = File.join(dir_path, self.public_send(options[:name]))
        full_path = File.join(tmp_dir_path, file_path)

        @paths << {
          tmp_dir_path: tmp_dir_path,
          dir_path:     dir_path,
          file_path:    file_path,
          full_path:    full_path,
        }

        @file_path = file_path

        mkdir { File.join(tmp_dir_path, dir_path) }

        File.open(full_path, 'wb') {|f| f.write(self.public_send(file_name).read) }
      end
    ensure
      @generated = true
    end

    def mkdir
      FileUtils.mkdir_p(yield)
    end

    def cleanup
      @paths.each { |path| FileUtils.remove_entry_secure path[:full_path] }
      @generated = false
    end

    def path_from_template_string(path)
      path.scan(/{{(?<value>[^{}]*)}}/).map do |dir_name|
        self.public_send(dir_name.first)
      end
    end
  end
end
