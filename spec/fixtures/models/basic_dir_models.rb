class BasicDirModel
  include DirModel::Model
  file :image, path: 'Sectors/sector_name', name: -> { image_name },
    regex: -> { /Zones\/Sector_(?<sector_id>.*)\/Zone_(?<zone_id>.*)\.(?<extension>png|jpg)/i }
end

class BasicImportDirModel < BasicDirModel
  include DirModel::Import
end

class BasicExportDirModel < BasicDirModel
  include DirModel::Export

  def image_name
    source_model.zone_name
  end

  def image
    source_model.zone
  end
end

# has_one

class ChildImportDirModel
  include DirModel::Model
  include DirModel::Import
  file :metadata, regex: -> { /Zones\/Sector_(?<sector_id>.*)\/Zone_(?<zone_id>.*)\.(?<extension>json)/i }
end

class ParentImportDirModel < BasicImportDirModel
  has_one :dependency, ChildImportDirModel
end

# has_many

class ZoneDirModel
  include DirModel::Model
  include DirModel::Import
  file :image, regex: ->(foreign_value) { "Zones\/#{foreign_value}\/Zone_(?<zone_id>.*)\.(?<extension>png|jpg)" }
end

class SectorDirModel
  include DirModel::Model
  file :image, regex: -> { /Sectors\/Sector_(?<sector_id>.*)\.(?<extension>png|jpg)/i }
end

class SectorImportDirModel < SectorDirModel
  include DirModel::Import

  has_many :dependencies, ZoneDirModel, foreign_key: :sector_name

  def sector_name
    'sector_1'
  end
end
