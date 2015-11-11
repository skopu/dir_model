shared_examples 'generate files' do
  describe "#generate" do
    subject { instance.generate { |dir| dir << source_model } }

    it 'should be generate files' do
      subject
      expect(File.exists?(instance.full_path(file_path))).to be_truthy
    end
  end
end
