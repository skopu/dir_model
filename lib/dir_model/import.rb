module DirModel
  module Import
    extend ActiveSupport::Concern

    attr_reader :context, :source_path, :index, :previous

    def initialize(path, options={})
      @source_path, @context = path, OpenStruct.new(options[:context])
      @index, @previous = options[:index], options[:previous].try(:dup)
      @load_state = :ghost
    end

    def matches
      load
      @match
    end

    def skip?
      load
      !@_match
    end

    def model
      raise NotImplementedError
    end

    def method
      raise NotImplementedError
    end

    def assign!
      load
      model.send(method, image)
    end

    def image
      @image ||= File.open(source_path)
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

    attr_reader :load_state

    def match?
      return if load_state == :loaded

      @_match ||= begin
        loader do
          self.class.files.each do |file, attributes|
            return true if (@match = (source_path||'').match(attributes[:regex].call))
          end
          false
        end
      end
    end
    alias_method :load, :match?

    def loader
      @load_state = :loading
      result = yield
      @load_state = :loaded
      result
    end

  end
end
