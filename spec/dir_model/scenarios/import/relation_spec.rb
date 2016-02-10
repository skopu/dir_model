require 'spec_helper'

describe DirModel::Import do
  let(:path)         { DirModel::Import::Path.new('spec/fixtures/unzip_dir') }
  let(:parent_klass) { SectorImportDir }

  it 'should fill children relations' do
    sector_dir_model = nil
    while _dir_model = parent_klass.next(path) do
      sector_dir_model = _dir_model unless _dir_model.skip?
    end

    zone_dir_model = sector_dir_model.zones.first
    expect(zone_dir_model).to be_a(ZoneDirModel)

    expect(zone_dir_model.metadata).to be_present
    expect(zone_dir_model.metadata).to be_a(ZoneMetadataDirModel)
  end
end
