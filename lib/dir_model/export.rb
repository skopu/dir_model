module DirModel
  module Export

    attr_reader :source_model, :context, :root_dir

    # @param [Model] source_model object to export to files
    # @param [Hash]  context
    def initialize(source_model, context={})
      @source_model = source_model
      @context      = OpenStruct.new(context)
      @root_dir     = Dir.mktmpdir
      @paths        = []
    end

    def paths
      generate unless generated?
      @paths
    end

    private

    def generated?
      !!@generated
    end

    def generate
      cleanup if generated?

      self.class.files.each do |file_name, options|
        dir_path  = File.join(*path_from_template_string(options[:path]))
        real_name = self.public_send(options[:name])
        file_path = File.join(dir_path, real_name)

        @paths << [real_name, dir_path, file_path]

        mkdir { File.join(root_dir, dir_path) }

        File.open(File.join(root_dir, file_path), 'wb') {|f| f.write(self.public_send(file_name).read) }
      end
    ensure
      @generated = true
    end

    def mkdir
      FileUtils.mkdir_p(yield)
    end

    def cleanup
      @paths.each { |path| FileUtils.remove_entry_secure path }
      @generated = false
    end

    def path_from_template_string(path)
      path.scan(/{{(?<value>[^{}]*)}}/).map do |dir_name|
        self.public_send(dir_name.first)
      end
    end
  end
end
