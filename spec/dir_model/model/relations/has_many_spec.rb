require 'spec_helper'

describe DirModel::Model::Relations do
  describe 'instance' do
    let(:options)  { {} }
    let(:instance) { SectorDirModel.new(nil, options) }

    describe '#child?' do
      specify do
        expect(instance).to_not be_child
        expect(instance).to_not be_has_many
        expect(instance).to_not be_has_relations
      end

      context 'with a parent' do
        let(:parent_instance) { SectorDirModel.new }
        let(:options)         { { parent: parent_instance } }

        specify do
          expect(instance).to be_child
          expect(instance).to_not be_has_many
          expect(instance).to_not be_has_relations
        end
      end
    end
  end

  context 'for ImportClass' do
    let(:source_path)     { 'zones/sector_1/zone_1.png' }
    let(:options)         { { parent: parent_instance } }
    let(:instance)        { ZoneDirModel.new(source_path, {}) }
    let(:parent_instance) { SectorImportDirModel.new('sectors/sector_1.png') }

    describe '#has_many' do
      it 'should have accessor defined' do
        expect(parent_instance).to be_respond_to(:dependencies)
        expect(parent_instance.dependencies).to be_a(Array)
        expect(parent_instance.dependencies).to be_empty
        expect(parent_instance).to be_respond_to(:has_many?)
        expect(parent_instance).to be_has_many
      end
    end

    describe '#append_dir_model' do
      subject { parent_instance.append_dir_models(source_path) }

      it 'appends the child and returns it' do
        expect(subject).to be_a(ZoneDirModel)
        expect(subject.source_path).to eql(source_path)
        expect(parent_instance.dependencies.count).to eql(1)
        expect(parent_instance.source_path).to eql('sectors/sector_1.png')
        expect(parent_instance.dependencies.first.source_path).to eql('zones/sector_1/zone_1.png')
        expect(parent_instance.dependencies.first.parent).to eql(parent_instance)
      end
    end
  end
end
