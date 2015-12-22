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
    let(:klass) { BasicImportDirModel }

    subject { instance.send :match? }

    context "when path doesn't match" do
      let(:source_path) { 'spec/fixtures/unzip_dir/sectors' }

      it 'should return false' do
        expect(subject).to eql(false)
        expect(instance.instance_variable_get(:@_match)).to eql(false)
      end
    end

    context 'when path match' do
      let(:source_path) { 'zones/sector_1/zone_1.png' }

      it 'should return true' do
        expect(subject).to eql(true)
        expect(instance.instance_variable_get(:@_match)).to eql(true)
      end

      it 'should match information' do
        expect(instance.matches[:sector_id]).to eql('1')
        expect(instance.matches[:zone_id]).to   eql('1')
        expect(instance.matches[:extension]).to eql('png')
      end

      it 'match should be accessible through methods' do
        expect(instance.sector_id).to eql('1')
        expect(instance.zone_id).to   eql('1')
        expect(instance.extension).to eql('png')
        expect { instance.unexisting_method }.to raise_error(NoMethodError)
      end
    end
  end

end
