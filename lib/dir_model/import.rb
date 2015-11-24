module DirModel
  module Import
    extend ActiveSupport::Concern

    attr_reader :context, :source_path, :index, :previous, :match

    def initialize(path, options={})
      @source_path, @context = path, OpenStruct.new(options[:context])
      @index, @previous = options[:index], options[:previous].try(:dup)
      skip? # Eager loading
    end

    def skip?
      !match?
    end

    module ClassMethods
      def next(path, context={}, previous=nil)
        path.read_path
        new(path.current_path, index: path.index, context: context, previous: previous)
      end
    end

    private

    def match?
      @match ||= begin
        self.class.files.each do |file, attributes|
          return true if (@match = source_path.match(attributes[:regex].call))
        end
        false
      end
    end
  end
end
