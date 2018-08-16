# frozen_string_literal: true

RSpec.describe Kernel::Hasherizer do
  subject { Kernel::Hasherizer }

  let(:shallow_hash_with_array) do
    {
      a: 1,
      b: [10, 11, 12]
    }
  end

  let(:deep_hash_with_array) do
    {
      a: 1,
      b: {
        b1: [10, 11, 12]
      }
    }
  end

  let(:deep_hash_with_mixed_types) do
    {
      a: 1,
      b: {
        b1: [
          10,
          { b1_array: 'string' },
          12
        ],
        b2: {
          b21: 'string',
          b22: true
        }
      }
    }
  end

  describe '.to_hash' do
    context 'when an instance of Kernel::Tree passed as a parameter' do
      it 'returns correct hash' do
        tree = Kernel::Tree.new
        tree.add_chain_link(:f1)
        tree.add_chain_link(:f2)
        tree.resolve_assigning(5)
        expect(subject.to_hash(tree)).to eq({ f1: { f2: 5 } })
      end
    end

  #   TODO: Write tests for cases above!
  end
end
