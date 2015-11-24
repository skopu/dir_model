module DirModel
  module Import
    extend ActiveSupport::Concern

    attr_reader :context, :source_path, :index, :previous, :match

    def initialize(path, options={})
      @source_path, @context = path, OpenStruct.new(options[:context])
      @index, @previous = options[:index], options[:previous].try(:dup)
    end

    def skip?
      !@_match
    end

    module ClassMethods
      def next(path, context={}, previous=nil)
        path.read_path
        new(path.current_path, index: path.index, context: context, previous: previous).tap do |import_model|
          import_model.send(:match?)
        end
      end
    end

    private

    def match?
      @_match ||= begin
        self.class.files.each do |file, attributes|
          return true if (@match = (source_path||'').match(attributes[:regex].call))
        end
        false
      end
    end
  end
end
