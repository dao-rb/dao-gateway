describe Dao::Gateway::Base do
  let(:entity) { Struct.new(:attribute, :initialized_with) }
  let(:transformer) { Dao::Gateway::ScopeTransformer.new(entity) }
  let(:source) { Object }
  let(:gateway) { described_class.new(source, transformer) }

  subject { gateway }

  its(:source) { is_expected.to eq source }
  its(:transformer) { is_expected.to eq transformer }
  its(:black_list_attributes) { is_expected.to eq [] }

  describe '#map' do
    it 'should raise error' do
      expect(subject.map(1, double).attribute).to eq 1
    end
  end

  describe '#save!' do
    it 'should raise error' do
      expect { subject.save!(double, double) }.to raise_error 'save! is not implemented'
    end
  end

  describe '#delete' do
    it 'should raise error' do
      expect { subject.delete(double) }.to raise_error 'delete is not implemented'
    end
  end

  describe '#chain' do
    it 'should raise error' do
      expect { subject.chain(double, double, double) }.to raise_error 'chain is not implemented'
    end
  end

  describe '#add_relations' do
    let(:scope) { double }

    it 'should return scope' do
      expect(subject.add_relations(scope, double, {})).to eq scope
    end
  end

  describe '#with_transaction' do
    it 'should raise error' do
      expect { subject.with_transaction }.to raise_error Dao::Gateway::TransactionNotSupported
    end
  end

  describe '#serializable_relations' do
    subject { gateway.serializable_relations(relations) }

    context 'when empty array' do
      let(:relations) { [] }

      it { is_expected.to eq [] }
    end

    context 'when simple array' do
      let(:relations) { [1, 2] }

      it { is_expected.to eq [1, 2] }
    end

    context 'with hash' do
      let(:relations) { [1, { a: :b }] }

      it { is_expected.to eq [1, { a: { include: :b } }] }
    end

    context 'with complex hash' do
      let(:relations) { [1, { a: [1, { b: :c }, { f: { g: :d } }] }] }

      it { is_expected.to eq [1, { a: { include: [1, { b: { include: :c } }, { f: { include: { g: { include: :d } } } }] } }] }
    end
  end
end
