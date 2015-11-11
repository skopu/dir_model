require 'spec_helper'

describe DirModel::Export::AggregateDir do
  let(:file_contents)    { File.new('spec/fixtures/image.png').read }
  let(:export_dir_class) { ImageExportDir }
  let(:instance)         { DirModel::Export::AggregateDir.new(ImageExportDir) }
  let(:file_paths) do
    [
      'Sectors/sector_name/zone_name.png',
      'Sectors/fu_sector_name/fu_zone_name.png',
    ]
  end

  let(:models) do
    [OpenStruct.new({
      id: 42,
      sector_name: 'sector_name',
      zone_name: 'zone_name',
      zone: File.new('spec/fixtures/image.png'),
    }),OpenStruct.new({
      id: 69,
      sector_name: 'fu_sector_name',
      zone_name: 'fu_zone_name',
      zone: File.new('spec/fixtures/image.png'),
    })]
  end

  describe "#generate" do
    subject do
      models.each do |model|
        instance.generate { |dir| dir << model }
      end
    end

    it 'should be generate files' do
      subject

      file_paths.each do |file_path|
        expect(
          File.exists?(
            File.join(instance.dir_path, file_path))
        ).to be_truthy
      end
    end
  end
end
