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

class ChildImportDirModel
  include DirModel::Model
  include DirModel::Import
  file :metadata, regex: -> { /Zones\/Sector_(?<sector_id>.*)\/Zone_(?<zone_id>.*)\.(?<extension>json)/i }
end

class ParentImportDirModel < BasicImportDirModel
  has_one :dependency, ChildImportDirModel
end
