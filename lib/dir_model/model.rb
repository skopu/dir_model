module DirModel
  module Model
    extend ActiveSupport::Concern

    included do
      include Utils
      include Files
      include Relations
      
      # @return [Model] return the parent, if this instance is a child
      attr_reader :parent
    end
    
    # @param [NilClass] path not used here, see {Input}
    # @param [Hash] options
    # @option options [String] :parent if the instance is a child, pass the parent
    def initialize(path=nil, options={})
      @parent = options[:parent]
    end

  end
end
