module DirModel
  module Model
    extend ActiveSupport::Concern

    included do
      include Utils
      include Files
    end
  end
end
