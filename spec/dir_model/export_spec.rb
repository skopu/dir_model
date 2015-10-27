require 'spec_helper'

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

describe DirModel::Export do
  let(:file_contents) { File.new("spec/fixtures/image.png").read }

  describe "#temp_path" do
    let(:path) { ImageDir.new.path }

    it "generates the right directory" do
      dir_path = path
      %w[level1 level2 testing.png].each do |entry_name|
        entries = Dir.clean_entries dir_path
        expect(entries).to match_array [entry_name]
        dir_path = File.join(dir_path, entry_name)
      end

      File.new(dir_path).read == file_contents
    end
  end
end