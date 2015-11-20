class ImageDir
  include DirModel::Model

  file :image, path: -> { "#{dir}/#{sub_dir}" }, name: -> { "#{image_name}.png" },
    regex: -> { /Zones\/Sector_(?<sector_id>.*)\/Zone_(?<zone_id>.*)\.(?<extension>png|jpg)/ }
end
