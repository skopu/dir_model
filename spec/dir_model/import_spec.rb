require 'spec_helper'

describe DirModel::Import do
  let(:klass) do
    Class.new do
      include DirModel::Model
      include DirModel::Import
    end
  end
  let(:context)     {{  }}
  let(:source_path) { nil }
  let(:instance)    { klass.new(source_path, context) }

  describe '#match?' do
    let(:klass) { ImageImportDir }

    subject { instance.send :match? }

    context "when path doesn't match" do
      let(:source_path) { 'spec/fixtures/unzip_dir/sectors' }

      it 'should return false' do
        expect(subject).to eql(false)
      end
    end

    context 'when path match' do
      let(:source_path) { 'zones/sector_1/zone_1.png' }

      it 'should return true' do
        expect(subject).to eql(true)
      end
    end
  end

end
