module DirModel
  module Export

    attr_reader :source_model, :context

    # @param [Model] source_model object to export to files
    # @param [Hash]  context
    def initialize(source_model, context={})
      @source_model = source_model
      @context      = OpenStruct.new(context)
      @root_path    = Dir.mktmpdir
    end

    def paths
      generate unless generated?
      entry_paths
    end

    private

    def entry_paths
      Dir.clean_entries(@root_path).map { |entry| File.join(@root_path, entry) }
    end

    def generated?
      !!@generated
    end

    def generate
      cleanup if generated?

      self.class.files.each do |file_name, options|
        dir_path  = instance_exec(&options[:path])
        file_path = File.join(dir_path, instance_exec(&options[:name]))

        mkdir { File.join(@root_path, dir_path) }

        File.open(File.join(@root_path, file_path), 'wb') {|f| f.write(self.public_send(file_name).read) }
      end
    ensure
      @generated = true
    end

    def cleanup
      FileUtils.remove_entry @root_path
      @generated = false
    end
  end
end
