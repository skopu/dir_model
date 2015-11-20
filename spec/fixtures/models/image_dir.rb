class ImageDir
  include DirModel::Model

  file :image, path: -> { "#{dir}/#{sub_dir}" }, name: -> { "#{image_name}.png" }
end
