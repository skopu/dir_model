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

**Ensure that `require zip_dir` occurs before `dir_model`**

## Future
Define a schema for the directory.
```ruby
class ImageDir
  include DirModel
  
  file :zone_image, path: "{{root}}/{{branch}}", name: "{{zone_name}}" 
end
```

To export, define your export model like [`ActiveModel::Serializer`](https://github.com/rails-api/active_model_serializers)
and generate the directory requirements:

```ruby
class ImageExportDir < ImageDir
  include DirModel::Export
  
  # below are method overrides with default implementation
  #
  # overriding is recommended
  #
  def root; source_model.root end
  def branch; source_model.branch end
  def zone_name; source_model.zone_name end
  
  # define your image source
  #
  # override with something like: File.new("path/to/image.png")
  #
  def zone_image
    source_model.zone_image
  end
end
```

To import, define your import model, which works like [`ActiveRecord`](http://guides.rubyonrails.org/active_record_querying.html)
wrapping over a directory:

```ruby
class ImageImportDir < ImageDir
  include DirModel::Import
  
  #
  # below are method overrides with default implementation
  #
  def root; "level1" end
  def branch; "level2" end
  def zone_name; "testing" end
  def zone_image; File.new("....") end
end
```