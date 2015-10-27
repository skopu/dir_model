if defined?(ZipDir)
  class ZipDir::Unzipper
    def add_and_cleanup_dir(dir)
      return unless dir.valid?

      dir.entry_paths.each { |path| add_path path }
      dir.cleanup
    end
  end
end