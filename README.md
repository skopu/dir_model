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
class ImageDir
  include DirModel

  file :image, path: -> { "#{dir}/#{sub_dir}" }, name: -> { "#{image_name}.png" }
end

class ImageExportDir < ImageDir
  include DirModel::Export

  def dir
    'Sectors'
  end

  def sub_dir
    source_model.sector_name
  end

  def image_name
    source_model.zone_name
  end

  def image
    source_model.zone
  end
end

fixture_models = [
  OpenStruct.new({
    id: 42,
    sector_name: 'sector_name',
    zone_name: 'zone_name',
    zone: File.new('spec/fixtures/image.png'),
  })
]

exporter = DirModel::Export::AggregateDir.new(ImageExportDir)

exporter.generate do |dir|
  models.each { |model| dir << model }
end

exporter.dir_path # => path of generated dir .../Sectors
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
