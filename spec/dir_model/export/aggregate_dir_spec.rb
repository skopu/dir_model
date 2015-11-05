require 'spec_helper'

describe DirModel::Export::AggregateDir do
  let(:file_contents)    { File.new('spec/fixtures/image.png').read }
  let(:source_model)     { ModelImage.new }
  let(:instance)         { DirModel::Export::AggregateDir.new(ImageExportDir) }

  describe "#generate" do
    subject { instance.generate { |dir| dir << source_model } }

    it 'should be generate files' do
      subject
      expect(instance.paths).to eql(['tmp/root_dir_42/Sectors/sector_name/zone_name.png'])
      expect(File.exists?(File.join(instance.copy_path, instance.paths.first))).to be_truthy
    end
  end
end
