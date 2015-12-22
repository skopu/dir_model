require 'spec_helper'

describe DirModel::Model::Files do
  let(:klass) do
    Class.new do
      include DirModel::Model
      
      file :one
      file :two
      
    end
  end
  let(:context)     {{  }}
  let(:source_path) { nil }
  let(:instance)    { klass.new(source_path, context) }
  
  it 'should raise an exception when DirModel have more of one file defined' do
    expect { instance }.to raise_error('You cannot define more of one file: but you can add relations, see README')
  end
end
