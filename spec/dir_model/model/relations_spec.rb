require 'spec_helper'

describe DirModel::Model::Relations do
  describe 'instance' do
    let(:options)  { {} }
    let(:instance) { BasicDirModel.new(nil, options) }

    describe '#child?' do
      specify do
        expect(instance).to_not be_child
        expect(instance).to_not be_has_one
        expect(instance).to_not be_has_relations
      end

      context 'with a parent' do
        let(:parent_instance) { BasicDirModel.new }
        let(:options)         { { parent: parent_instance } }

        specify do
          expect(instance).to be_child
          expect(instance).to_not be_has_one
          expect(instance).to_not be_has_relations
        end
      end
    end
  end

  context 'for ImportClass' do
    let(:source_path)     { 'zones/sector_1/zone_1.json' }
    let(:options)         { { parent: parent_instance } }
    let(:instance)        { BasicImportDirModel.new(source_path, {}) }
    let(:parent_instance) { ParentImportDirModel.new('zones/sector_1/zone_1.png') }
    
    describe '#has_one' do
      it 'should have accessor defined' do
        expect(parent_instance).to be_respond_to(:dependency)
        expect(parent_instance).to be_respond_to(:dependency=)
        expect(parent_instance).to be_respond_to(:has_one?)
        expect(parent_instance).to be_has_one
      end
    end

    describe '#append_dir_model' do
      subject { parent_instance.append_dir_model(source_path) }

      it 'appends the child and returns it' do
        expect(subject).to be_a(ChildImportDirModel)
        expect(subject.source_path).to eql(source_path)
        expect(parent_instance.dependency).to be_a(ChildImportDirModel)
        expect(parent_instance.source_path).to eql('zones/sector_1/zone_1.png')
        expect(parent_instance.dependency.source_path).to eql('zones/sector_1/zone_1.json')
        expect(parent_instance.dependency.parent).to eql(parent_instance)
      end
    end
  end
end