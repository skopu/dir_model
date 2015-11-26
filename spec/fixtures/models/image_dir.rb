class ImageDir
  include DirModel::Model

  file :image, path: 'Sectors/sector_name', name: -> { image_name },
    type: :image,
    regex: -> { /Zones\/Sector_(?<sector_id>.*)\/Zone_(?<zone_id>.*)\.(?<extension>png|jpg)/i }

end
