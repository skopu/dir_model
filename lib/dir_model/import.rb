module DirModel
  module Import
    extend ActiveSupport::Concern

    attr_reader :context, :source_path, :index, :previous

    def initialize(path, options={})
      @source_path, @context = path, OpenStruct.new(options[:context])
      @index, @previous = options[:index], options[:previous].try(:dup)
      @load_state = :ghost
      @file_infos = {}
    end

    def matches
      load
      file_infos[:options][:match]
    end

    def skip?
      load
      !@_match
    end

    def method_missing(name, *args, &block)
      load
      matches[name]
    rescue IndexError
      super
    end

    module ClassMethods
      def next(path, context={}, previous=nil)
        path.read_path
        new(path.current_path, index: path.index, context: context, previous: previous)
      end
    end

    private

    attr_reader :load_state, :file_infos

    def match?
      return if load_state == :loaded
      @_match = loader { find_match }
    end
    alias_method :load, :match?

    def find_match
      file_name = self.class.file_name
      options   = self.class.options(file_name)

      if match = (source_path||'').match(options[:regex].call)
        @file_infos = { file: file_name, options: options.merge(match: match) }
        return true
      end
      false
    end

    def loader
      @load_state = :loading
      result = yield
      @load_state = :loaded
      result
    end

  end
end
