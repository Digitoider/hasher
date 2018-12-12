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

    context 'array push' do
      it 'using `<<`' do
        h = subject.new
        h.array = []
        h.array << { item: 3 }
        # h.array = h.array << { item: 3 }
        # binding.pry
        expect(h.array[0].item).to eq(3)
      end

      it 'using `push`' do
        h = subject.new
        h.coords = []
        # binding.pry
        h.coords.push(lat: 45.36, lng: 63.54)
        expect(h.coords[0].lat).to eq(45.36)
        expect(h.coords[0].lng).to eq(63.54)
      end

      it 'deep' do
        h = subject.new
        h.a = [{ b: :jes }, 1, { 5 => [1, {}, 3 => 5] }]
        expect(h.a[0].b).to eq(:jes)
        expect(h.a[1]).to eq(1)
        expect(h.a[2][5][0]).to eq(1)
        expect(h.a[2]['5'][0]).to eq(1)
        expect(h.a[2][5][1].to_h).to eq({})
        expect(h.a[2][5][2][3]).to eq(5)
        expect(h.a[2][5][2][:'3']).to eq(5)
      end

      it 'included arrays' do
        h = subject.new
        h.arr1 = []
        h.arr1 << [2, { b: 3 }]
        h.arr1[0][1].c = [{}]
        h.arr1[0][1].c << [12]
        h.arr1[0][1].c[1].push('d' => 'yeah!')

        expect(h.arr1[0][0]).to eq(2)
        expect(h.arr1[0][1].c[0]).to be_a(subject)
        expect(h.arr1[0][1].c[1][0]).to eq(12)
        expect(h.arr1[0][1].c[1][1].d).to eq('yeah!')
      end
    end

    context 'array `[]=`' do
      it 'assigns' do
        h = Hasher.new

        h.items = []
        h.items[0] = { id: 0, gang: 'Beatles' }
        h.items[1] = 5
        h.items[3] = 'six'

        expect(h.items[0].id).to eq(0)
        expect(h.items[0].gang).to eq('Beatles')
        expect(h.items[1]).to eq(5)
        expect(h.items[2]).to eq(nil)
        expect(h.items[3]).to eq('six')
      end
    end
  end

  describe '#to_h' do
    context 'just created' do
      it 'empty hash' do
        h = subject.new
        expect(h.to_h).to eq({})
      end
    end

    context 'with `<<` and `push`' do
      it 'mixed' do
        h = subject.new
        h.arr1 = []
        h.arr1 << [2, { b: 3 }]
        h.arr1[0][1].c = [{}]
        h.arr1[0][1].c << [12]
        h.arr1[0][1].c[1].push('d' => 'yeah!')

        expected_result = {
          arr1: [
            [
              2,
              {
                b: 3,
                c: [{}, [12, d: 'yeah!']]
              }
            ]
          ]
        }

        expect(h.to_h).to eq(expected_result)
      end
    end

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

    context 'indifferent keys' do
      it 'symbolic key' do
        h = subject.new
        h[:machine] = 'ry'
        expect(h.to_h).to eq(machine: 'ry')
      end

      it 'string key' do
        h = subject.new
        h['mysterious'] = :sure_thing
        expect(h.to_h).to eq(mysterious: :sure_thing)
      end

      it 'symbolic string' do
        h = subject.new
        h[:' That is taste for ya '] = Struct
        expect(h.to_h).to eq(' That is taste for ya ' => Struct)
      end

      it 'via dot' do
        h = subject.new
        h.saint = 12
        expect(h.to_h).to eq(saint: 12)
      end

      it 'mixed' do
        h = subject.new
        h.universe = 9
        h['inside'] = 'of'
        h[:all] = 3.6
        h[:' of us '] = 'yeaaah'
        expected_result = {
          universe: 9,
          inside: 'of',
          all: 3.6,
          ' of us ' => 'yeaaah'
        }
        expect(h.to_h).to eq(expected_result)
      end

      it 'deep mixed' do
        h = subject.new
        h[' All'] = {
          mighty: :push,
          ' bziuuuu' => 'skibidish',
          'all_over': ['the', 'place', Array, {}]
        }
        h.gravity = 9.81
        h[:config] = :off
        h[:' symbolic string'] = 36
        h['geek'] = 'week'
        h[27] = 57

        expected_result = {
          ' All' => {
            mighty: :push,
            ' bziuuuu' => 'skibidish',
            'all_over': ['the', 'place', Array, {}]
          },
          gravity: 9.81,
          config: :off,
          ' symbolic string' => 36,
          geek: 'week',
          27 => 57
        }
        expect(h.to_h).to eq(expected_result)
      end
    end
  end

  context 'indifferent access' do
    it 'symbolic key' do
      h = subject.new
      h[:intellect] = true
      expect(h['intellect']).to eq(true)
      expect(h[:intellect]).to eq(true)
      expect(h.intellect).to eq(true)
    end

    it 'string key' do
      h = subject.new
      h['flow'] = 384
      expect(h['flow']).to eq(384)
      expect(h[:flow]).to eq(384)
      expect(h.flow).to eq(384)
    end

    it 'simple symbolic string' do
      h = subject.new
      h[:'here_we_go'] = 'doooooooog'
      expect(h[:'here_we_go']).to eq('doooooooog')
      expect(h['here_we_go']).to eq('doooooooog')
      expect(h.here_we_go).to eq('doooooooog')
    end

    it 'complex symbolic string' do
      h = subject.new
      h[:' Rick and Morty '] = 2.25
      expect(h[:' Rick and Morty ']).to eq(2.25)
      expect(h[' Rick and Morty ']).to eq(2.25)
    end

    it 'numeric key' do
      h = subject.new
      h[25] = 90.0
      expect(h[25]).to eq(90.0)
      expect(h['25']).to eq(90.0)
    end
  end

  describe '#initialize' do
    context 'with `Hash`' do
      it 'empty' do
        h = subject.new({})
        expect(h.to_h).to eq({})
      end

      it 'deep mixed' do
        value = {
          sinnerman: 'runs to the',
          'river': :and_then_he_is_like,
          " don't": {
            'you' => [:see, 'me', 'praing' => '?'],
            inside: [
              ['an'],
              { array: ['of', :an, Array] }
            ]
          }
        }
        expected_result = {
          sinnerman: 'runs to the',
          'river': :and_then_he_is_like,
          " don't" => {
            you: [:see, 'me', praing: '?'],
            inside: [
              ['an'],
              { array: ['of', :an, Array] }
            ]
          }
        }
        h = subject.new(value)
        expect(h.to_h).to eq(expected_result)
      end

      it 'numeric key' do
        h = subject.new(25 => 'embarassing', 8.25 => true)
        expect(h[25]).to eq('embarassing')
        expect(h[8.25]).to eq(true)
      end
    end
  end

  describe '#has_key?' do
    it 'true' do
      h = subject.new
      h.a = 5
      h[6] = :number

      expect(h.has_key?(:a)).to eq(true)
      expect(h.has_key?('a')).to eq(true)
      expect(h.has_key?(:'a')).to eq(true)

      expect(h.has_key?(6)).to eq(true)
      expect(h.has_key?('6')).to eq(true)
      expect(h.has_key?(:'6')).to eq(true)
    end

    it 'false' do
      h = subject.new
      h.a = 5

      expect(h.has_key?(:b)).to eq(false)
      expect(h.has_key?('b')).to eq(false)
      expect(h.has_key?(:'b')).to eq(false)
    end

    it 'mixed' do
      h = subject.new
      h[5] = :number

      expect(h.has_key?(5)).to eq(true)
      expect(h.has_key?('5')).to eq(true)
      expect(h.has_key?(:'5')).to eq(true)

      expect(h.has_key?(:p)).to eq(false)
      h.p = {}
      expect(h.has_key?(:p)).to eq(true)
    end
  end
end
