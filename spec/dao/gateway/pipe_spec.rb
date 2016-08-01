describe Dao::Gateway::Pipe do
  describe '#dup' do
    it 'should dup processors' do
      original = described_class.new
      original.postprocess 1

      copy = original.dup
      copy.postprocess 2

      expect(original.processors).to eq [1]
      expect(copy.processors).to eq [2, 1]
    end
  end
end
