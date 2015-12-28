module DirModel
  module Import
    extend ActiveSupport::Concern

    attr_reader :context, :source_path, :index, :previous

    def initialize(path, options={})
      super # set parent
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
        dir_model = new(path.current_path, index: path.index, context: context, previous: previous)

        if dir_model.has_relations?
          current_position = path.index
          path.rewind
          loop do # loop until find related file (has_one relation)
            path.read_path
            break if dir_model.append_dir_model(path.current_path, index: path.index, context: context)
          end
          path.set_position(current_position)
        end
        
        dir_model
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
