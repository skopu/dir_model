class ImageDir
  include DirModel

  file :my_image, path: "{{root}}/{{dir}}/{{sub_dir}}", name: :my_image_name
end
