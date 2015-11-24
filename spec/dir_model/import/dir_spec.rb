require 'spec_helper'

describe DirModel::Import::Dir do
  let(:source_path) { 'fixtures/unzip_dir' }
  let(:model_class) { ImageImportDir }
  let(:instance)    { described_class.new source_path, model_class, 'some_context' => true }
  let(:paths)  do
    [ 'spec/fixtures/unzip_dir/sectors',
      'spec/fixtures/unzip_dir/sectors/sector_1.png',
      'spec/fixtures/unzip_dir/zones',
      'spec/fixtures/unzip_dir/zones/sector_1',
      'spec/fixtures/unzip_dir/zones/sector_1/zone_1.png' ]
  end

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

  describe '#next' do
    subject { instance.next }

    it 'gets the paths until the end of the dir' do
      dir_model = nil
      (0..(paths.size-1)).each do |index| # From start to end of paths
        previous_dir_model = dir_model
        dir_model = instance.next
        expect(dir_model.class).to eql(model_class)
        expect(dir_model.source_path).to eql(paths[index])

        expect(dir_model.previous.try(:source_path)).to eql previous_dir_model.try(:source_path)
        expect(dir_model.index).to eql(index)
        expect(dir_model.context).to eql(OpenStruct.new(some_context: true))
      end

      2.times do # Iterate when aren't paths anymore
        expect(instance.next).to eql nil
        expect(instance.end?).to eql true
      end
    end
  end

  describe '#each' do
    subject { instance.each }

    context 'with skips on even paths' do
      let(:model_class) do
        Class.new(ImageImportDir) do
          def skip?; index % 2 == 1 end
          def self.name; 'ImageImportDirWithSkip' end
        end
      end

      it 'skips twice' do
        expect(subject.next.index).to eql(0)
        expect(subject.next.index).to eql(2)
        expect(subject.next.index).to eql(4)

        expect { subject.next }.to raise_error(StopIteration)
      end
    end
  end

end
