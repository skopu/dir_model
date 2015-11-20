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

  describe '#skip?' do
    subject { instance.skip? }

    it 'is false when match' do
      expect(subject).to be_falsey
    end

    it 'is true when does not match' do
      expect(instance).to receive(:match?) { false }
      expect(subject).to be_truthy
    end
  end
end
