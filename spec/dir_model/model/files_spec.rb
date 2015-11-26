require 'spec_helper'

describe DirModel::Model::Files do
  context 'with document without extension' do
    let(:klass) do
      Class.new do
        include DirModel::Model

        file :image,
          path: 'some_path',
          name: 'foo.json',
          type: :document
      end
    end

    it 'should raise an exception' do
      expect { klass.files }.to raise_error(
        "Expected extension should be define with 'type: :document', like 'extension: :json'"
      )
    end
  end
end
