module DirModel
  module Import
    extend ActiveSupport::Concern

    attr_reader :context, :source_path, :index, :previous

    def initialize(path, options={})
      @source_path, @context = path, OpenStruct.new(options[:context])
      @index, @previous      = options[:index], options[:previous].try(:dup)
      @load_state            = :ghost
      @file_infos            = {}
    end

    def skip?
      load
      !@_match
    end

    def method_missing(name, *args, &block)
      load
      @_match[name]
    rescue
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
      @_match = find_match.tap { @load_state = :loaded }
    end
    alias_method :load, :match?

    def find_match
      @_match = (source_path||'').match(self.class.options[:regex].call)
    end
  end
end
