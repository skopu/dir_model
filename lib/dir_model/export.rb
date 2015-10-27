module DirModel
  class Export
    def path
      generate unless generated?
      @temp_path
    end

    def entry_paths
      Dir.clean_entries(path).map {|entry| File.join path, entry }
    end

    def valid?
      !file_sources.any? { |file_source| file_source.nil? || file_source.read.nil? }
    rescue
      false
    end

    def file_sources
      self.class.files.map { |file| file_source(file) }
    end
    def file_source(file)
      public_send(self.class.file_source_method_name(file))
    end
    def file_name(file)
      File.join(*pwd, public_send(self.class.file_name_method_name(file)))
    end

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

    protected
    attr_reader :pwd

    def copy_file(file)
      File.open(file_name(file), 'wb') {|f| f.write(file_source(file).read) }
    end

    def _generate
      raise NotImplementedError.new("Missing #{self.class} implementation")
    end

    def mk_chdir(dir, *permissions_int)
      @pwd << dir
      Dir.mkdir(File.join(*pwd), *permissions_int)
      yield
    ensure
      @pwd.pop
    end

    class << self
      attr_reader :files

      def file(*files)
        @files ||= []
        @files += files
      end

      def file_name_method_name(file)
        "#{file}_name"
      end

      def file_source_method_name(file)
        "#{file}_source"
      end
    end
  end
end