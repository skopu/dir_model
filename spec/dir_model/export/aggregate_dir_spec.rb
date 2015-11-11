require 'spec_helper'

describe DirModel::Export::AggregateDir do
  let(:file_contents)    { File.new('spec/fixtures/image.png').read }
  let(:source_model)     { ModelImage.new }
  let(:export_dir_class) { ImageExportDir }
  let(:instance)         { DirModel::Export::AggregateDir.new(ImageExportDir) }
  let(:file_path)        { 'Sectors/sector_name/zone_name.png' }

  it_behaves_like 'generate files'

  context 'with string' do
    let(:export_dir_class) do
      Class.new do
        include DirModel
        file :image, path: -> { 'Sectors/sector_name/zone_name.png' }, name: -> { 'zone_name.png' }
        include DirModel::Export
      end
    end

    it_behaves_like 'generate files'
  end

end
