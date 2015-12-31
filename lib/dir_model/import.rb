module DirModel
  module Import
    extend ActiveSupport::Concern

    attr_reader :context, :source_path, :index, :previous, :foreign_value

    def initialize(path, options={})
      super # set parent
      @source_path, @context = path, OpenStruct.new(options[:context])
      @index, @previous      = options[:index], options[:previous].try(:dup)
      @load_state            = :ghost
      @file_infos            = {}
      @foreign_value         = options[:foreign_value]
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

        unless dir_model.skip?
          if dir_model.has_relations?
            if dir_model.has_one?
              search(path, context) do
                dir_model.append_dir_model(path.current_path, index: path.index, context: context)
              end
            end
            if dir_model.has_many?
              search(path, context) do
                dir_model.append_dir_models(path.current_path, index: path.index, context: context)
              end
            end
          end
        end

        dir_model
      end

      private

      def search(path, context)
        return unless block_given?

        current_position = path.index
        path.rewind
        while !path.end? do
          path.read_path
          yield
        end
        path.set_position(current_position)
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
      @_match = (source_path||'').match(get_regexp)
    end

    def get_regexp
      if foreign_value
        Regexp.new(self.class.options[:regex].call(foreign_value), Regexp::IGNORECASE)
      else
        self.class.options[:regex].call
      end
    end
  end
end
