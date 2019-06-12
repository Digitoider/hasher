# frozen_string_literal: true

RSpec.describe Hasher do
  subject { Hasher }

  describe '.indifferentiate_keys' do
    it 'no key passed' do
      expect(subject.indifferentiate_keys).to eq([])
    end

    it 'many keys passed' do
      string_keys = subject.indifferentiate_keys(:a, 'b', :'c', 'd e')
      expect(string_keys).to eq([:a, :b, :c, 'd e'])

      numeric_keys = subject.indifferentiate_keys(4.5, 3, '6', '1.8', :'17.4')
      expect(numeric_keys).to eq(['4.5', '3', '6', '1.8', '17.4'])
    end
  end

  describe '.indifferentiate_key' do
    it 'success' do
      expect(subject.indifferentiate_key('a')).to eq(:a)
      expect(subject.indifferentiate_key(:a)).to eq(:a)
      expect(subject.indifferentiate_key(:'a')).to eq(:a)
      expect(subject.indifferentiate_key(1)).to eq('1')
      expect(subject.indifferentiate_key(2.3)).to eq('2.3')
      expect(subject.indifferentiate_key('4.5')).to eq('4.5')
    end
  end

  describe '.[]' do
    it 'creates a new instance of `Hasher` according to passed values' do
      expect(subject[]).to eq({})
      expect(subject[[:a, 1], ['b', 2]]).to eq(a: 1, b: 2)
      expect(subject[[1, 100], ['2', 200]]).to eq(1 => 100, 2 => 200)
    end
  end
end
