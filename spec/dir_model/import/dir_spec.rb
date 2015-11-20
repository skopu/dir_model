require 'spec_helper'

describe DirModel::Import::Dir do
  let(:source_path) { 'fixtures/unzip_dir' }
  let(:model_class) { ImageImportDir }
  let(:instance)    { described_class.new source_path, model_class, 'some_context' => true }

  describe '#context' do
    it 'symbolizes the context' do
      expect(instance.context[:some_context]).to eql(true)
    end
  end

  describe '#reset' do
    subject { instance.reset }

    context 'at the end of paths' do
      before { while instance.next; end }

      it 'resets and starts at the first path' do
        subject
        expect(instance.index).to eql(-1)
        expect(instance.current_dir_model).to be_nil
        expect(instance.next.source_path).to eql('spec/fixtures/unzip_dir/sectors')
      end
    end
  end
end
