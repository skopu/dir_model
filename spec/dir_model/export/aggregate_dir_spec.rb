require 'spec_helper'

describe DirModel::Export::AggregateDir do
  let(:file_contents)    { File.new('spec/fixtures/image.png').read }
  let(:image_export_dir) { ImageExportDir }
  let(:context)          {{}}
  let(:dir_path)         { 'tmp/root_dir_42/Sectors/sector_name/zone_name' }
  let(:source_model)     { ModelImage.new }

  before do
    DirModel::Export::AggregateDir.new(image_export_dir, context).generate do |dir|
      dir << source_model
    end
  end

  it '' do
    expect(File.new(dir_path).read).to eql(file_contents)
  end

end
