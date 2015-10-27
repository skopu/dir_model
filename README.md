# DirModel

Import and export directories with an ORM-like interface.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'dir_model'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dir_model

## Usage

### Export
```ruby
class ImageDir < DirModel::Export
  file :zone_image

  def zone_image_source
    File.new("spec/fixtures/image.png")
  end
  def zone_image_name
    "testing.png"
  end

  def _generate
    mk_chdir "level1" do
      mk_chdir "level2" do
        copy_file :zone_image
      end
    end
  end
end

image_dir = ImageDir.new
image_dir.path # => path representing the above: "#{image_dir.path}/level1/level2/testing.png"
```

## zip_dir
Use [`zip_dir`](https://github.com/FinalCAD/zip_dir) to zip DirModel::Export instances:
```ruby
# Zip
zipper = ZipDir::Zipper.new
zip_file = zipper.generate do |z|
  z.add_and_cleanup_dir __dir_model_export__
end
```

**Ensure that `require zip_dir` occurs before `dir_model` (for now)**