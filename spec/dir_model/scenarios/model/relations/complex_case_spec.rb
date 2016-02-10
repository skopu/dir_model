require 'spec_helper'

describe DirModel::Model::Relations do
  context 'for ImportClass' do
    describe 'complex case' do
      subject do
        DirModel::Import::Dir.new('spec/fixtures/unzip_dir', SectorImportDirModel, {}).each
      end

      it 'Don\'t throw There are more of one metadata' do
        expect { subject.next }.to_not raise_error
      end

      it 'should work properly' do
        dir_model = subject.next
        expect(dir_model).to be_a(SectorImportDirModel)
        expect(dir_model.source_path).to eql('spec/fixtures/unzip_dir/sectors/sector_1.png')
        expect(dir_model.metadata).to be_a(SectorMetadataImportDirModel)
        expect(dir_model.metadata.source_path).to eql('spec/fixtures/unzip_dir/sectors/sector_1.json')
        expect(dir_model.children).to be_a(Array)
        expect(dir_model.children.size).to eql(1)
        expect(dir_model.children.first).to be_a(ZoneImportDirModel)
        expect(dir_model.children.first.source_path).to eql('spec/fixtures/unzip_dir/zones/sector_1/zone_1.png')
        expect(dir_model.children.first.metadata).to be_a(ZoneMetadataImportDirModel)
        expect(dir_model.children.first.metadata.source_path).to eql('spec/fixtures/unzip_dir/zones/sector_1/zone_1.json')
      end
    end
  end
end
