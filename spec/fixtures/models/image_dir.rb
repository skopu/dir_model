class ImageDir
  include DirModel

  file :image, path: -> { "#{root}/#{dir}/#{sub_dir}" }, name: -> { "#{image_name}.png" }
end
