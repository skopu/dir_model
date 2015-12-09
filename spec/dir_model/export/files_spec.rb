require 'spec_helper'

describe DirModel::Export::Files do
  let(:instance) { ImageExportDir.new(nil,{}) }

  it 'should have image_skip? method' do
    expect(instance).to be_respond_to(:image_skip?)
    expect(instance.image_skip?).to eql(false)
  end
end
