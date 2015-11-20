module DirModel
  module Import
    extend ActiveSupport::Concern

    attr_reader :context, :source_path

    # @param [Hash] context
    def initialize(path, context={})
      @context = OpenStruct.new(context)
      @source_path = path
    end

    def skip?
      !match?
    end

    module ClassMethods
      def next(path, context={})
        path.read_path
        new(path.current_path, index: path.index, context: context)
      end
    end

    private

    def match?
      true # raise NotImplementedError.new
    end
  end
end
