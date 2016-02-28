require 'spec_helper'

describe DirModel::Model::Relations do
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
      subject do
        parent_instance
          .append_dir_model(source_path, { relation_name: :dependency,
            options: { foreign_key: :sector_name, dir_model_class: ChildImportDirModel }})
      end

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
