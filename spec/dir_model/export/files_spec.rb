require 'spec_helper'

describe DirModel::Export::Files do
  let(:source_model) { double(zone: double(present?: true)) }
  let(:klass)        { BasicExportDirModel }
  let(:instance)     { klass.new(source_model, {}) }

  it 'should have image_skip? method' do
    expect(instance).to be_respond_to(:image_skip?)
    expect(instance.image_skip?).to eql(false)
  end

  shared_examples 'call source_model file and file extension method' do |extension|
    it 'should have :my_image method' do
      expect(instance).to be_respond_to(:my_image)
      expect(instance.my_image.read).to eql('file content')
      expect(instance).to be_respond_to(:my_image_extension)
      expect(instance.my_image_extension).to eql(extension)
    end
  end

  describe '.define_file_method' do
    let(:klass)  { Class.new(BasicExportDirModel) { file :my_image } }

    context 'regular file method' do
      let(:source_model) { OpenStruct.new({my_image: double(:file, read: 'file content')}) }
      it_behaves_like 'call source_model file and file extension method', nil
    end

    context 'carrierwave uploader file method' do
      let(:source_model) { OpenStruct.new({my_image: double(:file, file: double(extension: :png, read: 'file content'))}) }
      it_behaves_like 'call source_model file and file extension method', :png
    end
  end
end
