# frozen_string_literal: true

RSpec.describe Hasher do
  subject { Hasher }

  describe '#method_missing' do
    context 'shallow' do
      it 'with simple values' do
        h = subject.new
        h.a = 1
        expect(h.a).to eq(1)
        h.b = 2
        expect(h.b).to eq(2)
        expect(h.a).to eq(1)
      end

      it 'with array' do
        h = subject.new
        h.a = [1, 2]
        expect(h.a).to eq([1, 2])
        h.b = 2
        expect(h.b).to eq(2)
        expect(h.a).to eq([1, 2])
      end

      it 'with hash' do
        h = subject.new
        h.a = { b: 2 }
        expect(h.a.b).to eq(2)
        expect(h.a.c).to eq(nil)
        expect(h.unknown).to eq(nil)
      end

      it 'with consts' do
        h = subject.new
        h.arr_class = Array
        expect(h.arr_class).to eq(Array)
        expect(h.nothing).to eq(nil)
      end
    end

    context 'deep' do
      it 'hash in array' do
        h = subject.new
        h.a = 5
        h.array = [1, { c: 2 }]
        expect(h.a).to eq(5)
        expect(h.array[0]).to eq(1)
        expect(h.array[1].c).to eq(2)
        expect(h.array[1].d).to eq(nil)
      end

      it 'array in hash' do
        h = subject.new
        h.a = { b: [1, 2] }
        expect(h.a.b).to eq([1, 2])
        expect(h.a.b[0]).to eq(1)
        expect(h.a.b[1]).to eq(2)
        expect(h.a.b[2]).to eq(nil)
      end

      it 'mixed' do
        h = subject.new
        h.a = 1
        h.b = [2, { c: 3, d: 'str', e: [FalseClass, 5, { d: 6 }] }]
        h.c = { left: { overs: true }, back: [75, { at: 84 }] }
        h.c.false = false
        h.c.true = true
        h.array_class = Array
        expect(h.a).to eq(1)
        expect(h.b).to be_kind_of(Array)
        expect(h.b[0]).to eq(2)
        expect(h.b[1].c).to eq(3)
        expect(h.b[1].d).to eq('str')
        expect(h.b[1].e).to be_kind_of(Array)
        expect(h.b[1].undefined_key).to eq(nil)
        expect(h.b[1].e[0]).to eq(FalseClass)
        expect(h.b[1].e[1]).to eq(5)
        expect(h.b[1].e[2].d).to eq(6)
        expect(h.b[1].e[2].unknown).to eq(nil)
        expect(h.c.left.overs).to eq(true)
        expect(h.c.back).to be_kind_of(Array)
        expect(h.c.back.first).to eq(75)
        expect(h.c.back[1].at).to eq(84)
        expect(h.c.false).to eq(false)
        expect(h.c.true).to eq(true)
        expect(h.array_class).to eq(Array)
      end
    end

    context 'reassignments' do
      it 'mixed' do
        h = subject.new
        h.a = 1
        expect(h.a).to eq(1)
        h.b = [Numeric, 1, { c: [2, { d: 3 }] }]
        expect(h.b[0]).to eq(Numeric)
        expect(h.b[1]).to eq(1)
        expect(h.b[2].c[0]).to eq(2)
        expect(h.b[2].c[1].d).to eq(3)
        h.b[2].c = false
        expect(h.b[2].c).to eq(false)
        expect(h.b[0]).to eq(Numeric)
        expect(h.b[1]).to eq(1)
        h.b = { deep: { inside: { our: { minds: { lies: 'awareness' } } } } }
        expect(h.b.deep.inside.our.minds.lies).to eq('awareness')
        expect(h.b.deep.mess).to eq(nil)
      end
    end
  end

  describe '#to_h' do
    context 'deep' do
      it 'mixed' do
        h = subject.new
        h.a = [
          1,
          {
            b: 2,
            c: {
              d: [13, Numeric],
              e: nil
            }
          }
        ]
        h.hold = {}
        h.it = Hasher.new
        h.it.man = false
        h.sym = :symbol
        h.deep = {}
        h.deep.empty_hash = {}

        expected_result = {
          a: [
            1,
            {
              b: 2,
              c: {
                d: [13, Numeric],
                e: nil
              }
            }
          ],
          hold: {},
          it: {
            man: false
          },
          sym: :symbol,
          deep: {
            empty_hash: {}
          }
        }

        expect(h.to_h).to eq(expected_result)
      end
    end
  end
end
