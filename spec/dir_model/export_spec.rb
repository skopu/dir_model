require 'spec_helper'

describe DirModel::Export do
  let(:klass) do
    Class.new do
      include DirModel::Model
      include DirModel::Export
    end
  end
  let(:context) {{}}
  let(:source_model) { nil }
  let(:instance) { klass.new(source_model, context) }

  before do
    instance.instance_variable_set(:@generated, true)
  end

  it '#cleanup' do
    expect { instance.send(:cleanup) }.to change {
      File.exists?(
        instance.instance_variable_get(:@root_path)
      )
    }.from(true).to(false) & change {
      instance.send(:generated?)
    }.from(true).to(false)
  end
end
