# Upgrading

# Upgrading from 0.1.0 to 0.2.0

You have to change

```
def _generate
  mk_chdir "level1" do
    mk_chdir "level2" do
      copy_file :zone_image
    end
  end
end
```

for a DirModel

```
class ImageDir
  include DirModel::Model

  file :image, path: -> { "#{dir}/#{sub_dir}" }, name: -> { "#{image_name}.png" }
end
```
see the README
