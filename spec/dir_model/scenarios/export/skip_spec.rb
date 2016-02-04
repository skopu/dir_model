require 'rspec/expectations'

RSpec::Matchers.define :be_a_empty_directory? do

  failure_message_when_negated do |actual|
    msg << "expected : #{pp(['.', '..'])}"
    msg << "     got : #{pp(Dir.entries(actual))}"
    msg
  end

  match do |actual|
    Dir.entries(actual) == ['.', '..']
  end
end

require 'spec_helper'

describe DirModel::Export::AggregateDir do
  let(:instance) { DirModel::Export::AggregateDir.new(BasicExportDirModel) }

  describe "#generate" do
    subject do
      models.each do |model|
        model.zone = nil # set file to nil
        instance.generate { |dir| dir << model }
      end
    end

    it 'should not generate files' do
      subject
      expect(instance.dir_path).to be_a_empty_directory?
    end
  end
end
