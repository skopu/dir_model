require 'spec_helper'

describe DirModel::Model::Relations do
  let(:options) { {} }

  context '#has_many' do
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

  context '#has_one' do
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
end
