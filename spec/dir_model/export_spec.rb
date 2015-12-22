require 'spec_helper'

describe DirModel::Export do
  let(:klass)        { BasicExportDirModel }
  let(:context)      {{}}
  let(:source_model) { nil }
  let(:instance)     { klass.new(source_model, context) }

  before { instance.instance_variable_set(:@generated, true) }

  it '#cleanup' do
    expect { instance.send(:cleanup) }.to change {
      File.exists?(
        instance.instance_variable_get(:@root_path)
      )
    }.from(true).to(false) & change {
      instance.send(:generated?)
    }.from(true).to(false)
  end

  context 'with image' do
    it 'should be guess extension' do
      expect(instance.send(:ensure_extension, 'path/file.png', :image)).to eql('path/file.png')
    end
  end
end
