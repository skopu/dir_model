class ImageDir
  include DirModel

  file :image, path: -> { "#{dir}/#{sub_dir}" }, name: -> { "#{image_name}.png" }
end
