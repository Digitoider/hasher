# frozen_string_literal: true

RSpec.describe Hasher do
  subject { Hasher }

  describe '#to_h' do
    it 'success' do
      h = subject.new

      h.to_h = :demo
      expect(h.to_h).to eq(to_h: :demo)
      expect(h[:to_h]).to eq(:demo)
      expect(h['to_h']).to eq(:demo)
    end
  end

  describe '#dup' do
    it 'success' do
      h = subject.new

      h.dup = { duplicated: true }
      expect(h.to_h).to eq(dup: { duplicated: true })
      expect(h[:dup]).to eq(duplicated: true)
      expect(h['dup']).to eq(duplicated: true)

      copy = h.dup
      copy.dup = { flow: 'exists' }
      expect(h).to eq(dup: { duplicated: true })
      expect(copy).to eq(dup: { flow: 'exists' })
    end
  end

  describe '#dig' do
    it 'success' do
      h = subject.new
      h.dig = 5
      expect(h.dig).to eq(5)
      h.dig = [{}, { b: 2 }, 3, [4, 5]]
      expect(h.dig[0].does_not_exist).to eq(nil)
      expect(h.dig[1].b).to eq(2)
      expect(h.dig[1].c).to eq(nil)
      expect(h.dig[2]).to eq(3)
      expect(h.dig[3]).to eq([4, 5])

      expect(h.dig.dig(1).dig('b')).to eq(2)
    end
  end

  describe '#each' do
    context 'whithout block' do
      it 'assigns and extracts' do
        h = subject.new
        h.each = { b: 12 }
        expect(h.each.b).to eq(12)
      end
    end
  end

  describe '#each_value' do
    context 'whithout block' do
      it 'assigns and extracts' do
        h = subject.new
        h.each_value = { the: { king: { of: { the: { day: 'honto ni?' } } } } }
        expect(h.each_value.the.king.of.the.day).to eq('honto ni?')
      end
    end
  end

  describe '#delete' do
    it 'success' do
      h = subject.new
      h.delete = true
      expect(h.delete).to eq(true)
      expect(h.to_h).to eq(delete: true)
    end
  end

  describe '#delete_if' do
    it 'success' do
      h = subject.new
      h.delete_if = 'assigning'
      expect(h.delete_if).to eq('assigning')
      expect(h.to_h).to eq(delete_if: 'assigning')
    end
  end
end
