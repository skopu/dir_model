require 'spec_helper'

describe DirModel::Import do
  let(:klass) do
    Class.new do
      include DirModel::Model
      include DirModel::Import
    end
  end
  let(:context) {{}}
  let(:source_model) { nil }
  let(:instance) { klass.new(source_model, context) }
end
