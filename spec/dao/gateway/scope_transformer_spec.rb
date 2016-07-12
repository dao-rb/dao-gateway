describe Dao::Gateway::ScopeTransformer do
  let(:entity) { Struct.new(:attribute, :initialized_with) }
  let(:transformer) do
    described_class.new(entity).tap do |t|
      t.associations = [:association]
    end
  end

  describe '#many' do
    subject { transformer.many([1,2]) }

    it { is_expected.to be_a Array }
    its(:count) { is_expected.to eq 2 }
    its(:to_a) { is_expected.to include instance_of(entity) }

    it 'should contain entities with valid attributes' do
      expect(subject.collect(&:attribute)).to eq [1, 2]
    end

    it 'should contain initialized_with' do
      expect(subject.collect(&:initialized_with)).to eq [[:association], [:association]]
    end
  end

  describe '#one' do
    subject { transformer.one([1]) }

    it { is_expected.to be_a entity }

    it 'should contain entities with valid attributes' do
      expect(subject.attribute).to eq 1
    end

    it 'should contain initialized_with' do
      expect(subject.initialized_with).to eq [:association]
    end
  end

  describe '#other' do
    subject { transformer.other(1) }

    it { is_expected.to eq 1 }
  end

  describe '#other' do
    subject { transformer }

    its(:export_attributes_black_list) { is_expected.to eq [] }
  end
end
