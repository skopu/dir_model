require 'spec_helper'

describe DirModel::Export::Files do
  let(:source_model) { nil }
  let(:klass)        { ImageExportDir }
  let(:instance)     { klass.new(source_model, {}) }

  it 'should have image_skip? method' do
    expect(instance).to be_respond_to(:image_skip?)
    expect(instance.image_skip?).to eql(false)
  end

  shared_examples 'call source_model file method' do
    it 'should have :my_image method' do
      expect(instance).to be_respond_to(:my_image)
      expect(instance.my_image).to eql('file content')
    end
  end

  describe '.define_file_method' do
    let(:klass)  { Class.new(ImageExportDir) { file :my_image } }

    context 'regular file method' do
      let(:source_model) { OpenStruct.new({my_image: 'file content'}) }
      it_behaves_like 'call source_model file method'
    end

    context 'carrierwave uploader file method' do
      let(:source_model) { OpenStruct.new({my_image: double(file: 'file content')}) }
      it_behaves_like 'call source_model file method'
    end
  end
end
