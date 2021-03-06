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
        h.it = subject.new
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

  describe '#dup' do
    it 'success' do
      h = subject.new(story: { author: 'Missing Guy' })

      copy = h.dup
      expect(copy).to eq(h)

      copy.story.author = 'Teleporter'
      expect(h.story.author).to eq('Missing Guy')

      copy.mental_mood = 'is pretty good'
      expect(h.mental_mood).to eq(nil)
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

  describe '#key?' do
    it 'true' do
      h = subject.new
      h.a = 5
      h[6] = :number

      expect(h.key?(:a)).to eq(true)
      expect(h.key?('a')).to eq(true)
      expect(h.key?(:'a')).to eq(true)

      expect(h.key?(6)).to eq(true)
      expect(h.key?('6')).to eq(true)
      expect(h.key?(:'6')).to eq(true)
    end

    it 'false' do
      h = subject.new
      h.a = 5

      expect(h.key?(:b)).to eq(false)
      expect(h.key?('b')).to eq(false)
      expect(h.key?(:'b')).to eq(false)
    end

    it 'mixed' do
      h = subject.new
      h[5] = :number

      expect(h.key?(5)).to eq(true)
      expect(h.key?('5')).to eq(true)
      expect(h.key?(:'5')).to eq(true)

      expect(h.key?(:p)).to eq(false)
      h.p = {}
      expect(h.key?(:p)).to eq(true)
    end
  end

  describe '#empty?' do
    it 'true' do
      h = subject.new

      expect(h.empty?).to eq(true)
    end

    it 'false' do
      h = subject.new(knowladge: 'is awesome')

      expect(h.empty?).to eq(false)
    end

    it 'after removal' do
      h = subject.new

      h.rick = 'Rick'
      expect(h.empty?).to eq(false)
      h.delete(:rick)
      expect(h.empty?).to eq(true)
    end
  end

  describe '#value?' do
    it 'simple' do
      h = subject.new

      expect(h.value?(5)).to eq(false)
      h.a = 5
      expect(h.value?(5)).to eq(true)
    end

    it 'deep' do
      h = subject.new

      h.a = [1, { b: 2, c: [3, 4] }, [5, 6]]
      expect(h.value?([1, { b: 2, c: [3, 4] }, [5, 6]])).to eq(true)
      a = h.a
      expect(h.value?(a)).to eq(true)
    end
  end

  describe '#dig' do
    it 'chain of keys exists' do
      hash = {
        a: {
          'b' => {
            3 => 'exists'
          }
        }
      }
      h = subject.new(hash)

      expect(h.dig(:a, 'b', 3)).to eq('exists')
      expect(h.dig('a', :b, '3')).to eq('exists')
      expect(h.dig(:'a', :'b', :'3')).to eq('exists')
      expect(h.dig('a', 'b', '3')).to eq('exists')
      expect(h.dig(:a, :b, 3)).to eq('exists')
    end

    it 'chain of keys does not exist' do
      h = subject.new
      expect(h.dig(:a, :b, :c, 'd', 15)).to eq(nil)
      expect(h.dig(:a)).to eq(nil)
      expect(h.dig('a')).to eq(nil)
      expect(h.dig(4)).to eq(nil)
      expect(h.dig('5')).to eq(nil)
      expect(h.dig(6, '9')).to eq(nil)
    end
  end

  describe '#map' do
    it 'only keys' do
      h = subject.new
      h.a = 5
      h[4] = 'sugar'
      h.v = nil

      expect(h.map { |key| key }).to eq([:a, '4', :v])
    end

    it 'with values' do
      h = subject.new
      h.a = 5
      h[4] = 'sugar'
      h.v = nil

      expect(h.map { |_key, value| value }).to eq([5, 'sugar', nil])
    end

    it 'transforming values' do
      h = subject.new
      h.a = 3
      h.b = 6
      h.c = 9

      expect(h.map { |_key, value| value + 1 }).to eq([4, 7, 10])
    end
  end

  describe '#each' do
    it 'preforms `#each` on keys and values' do
      h = subject.new
      h.a = { id: 1 }
      h.b = { id: 2 }
      h.c = { id: 3 }

      result = []
      h.each { |key, value| result << "#{key}::#{value.id}" }
      expect(result).to eq(['a::1', 'b::2', 'c::3'])
    end
  end

  describe '#each_value' do
    it 'preforms `#each` on values only' do
      h = subject.new
      h.a = { id: 1 }
      h.b = { id: 2 }
      h.c = { id: 3 }

      result = []
      h.each_value { |value| result << ":#{value.id}:" }
      expect(result).to eq([':1:', ':2:', ':3:'])
    end
  end

  describe '#==' do
    context '`Hash` with `Hasher`' do
      it 'true' do
        hash = { a: [5, { 7.8 => '11', b: 12 }] }
        h = subject.new(hash)
        expect(h == hash).to eq(true)
      end

      it 'false' do
        hash = { '5' => 'string key' }
        h = subject.new(hash)
        expect(h == hash).to eq(false)
      end
    end

    context '`Hasher` with `Hasher`' do
      it 'true' do
        h1 = subject.new(a: 1, b: 2, c: [1, { 4 => 5 }])
        h2 = subject.new('a' => 1, b: 2, c: [1, { '4' => 5 }])
        expect(h1 == h2).to eq(true)
        expect(h2 == h1).to eq(true)
      end

      it 'false' do
        h1 = subject.new
        h2 = subject.new

        h1.a = 5
        h2.a = 6

        expect(h1 == h2).to eq(false)
      end
    end
  end

  describe '#delete' do
    it 'returns removed value' do
      h = subject.new

      h.a = 5
      expect(h.delete('a')).to eq(5)
    end

    context 'composite' do
      it 'key exists' do
        h = subject.new
        h.a = 5
        h.b = 7
        expect(h.to_h).to eq(a: 5, b: 7)
        result = h.delete(:a)
        expect(result).to eq(5)
        expect(h.a).to eq(nil)
        expect(h.to_h).to eq(b: 7)
      end

      it 'key does not exist' do
        h = subject.new
        h.a = { b: [1, 3 => 'three', k: 'awesome'] }
        result = h.delete(:b)
        expect(result).to eq(nil)
        expect(h.to_h).to eq(a: { b: [1, 3 => 'three', k: 'awesome'] })
      end
    end

    context 'leaf' do
      it 'key exists' do
        h = subject.new
        h.a = { unbelievable: { power: 1 } }
        expect(h.delete('a').to_h).to eq(unbelievable: { power: 1 })
        expect(h.to_h).to eq({})
      end

      it 'key does not exist' do
        h = subject.new
        expect(h.delete('abra')).to eq(nil)
        expect(h.to_h).to eq({})
      end
    end

    context 'indifferent keys' do
      it 'string key' do
        h = subject.new
        h.dog = { b: 'labrador' }
        h.style = ['extreme']
        result = h.delete('dog')
        expect(result.to_h).to eq(b: 'labrador')
        expect(h.to_h).to eq(style: ['extreme'])
      end

      it 'symbolic key' do
        h = subject.new
        h.gorillaz = 'is a nice gang'
        value = h.delete(:gorillaz)
        expect(value).to eq('is a nice gang')
        expect(h.to_h).to eq({})
      end

      it 'numeric key' do
        h = subject.new
        h[15]  = 'fifteen'
        h[6.6] = 'six point six'
        h[30]  = 'thirty'

        expect(h.delete(15)).to eq('fifteen')
        expect(h.to_h).to eq(6.6 => 'six point six', 30 => 'thirty')

        expect(h.delete('6.6')).to eq('six point six')
        expect(h.to_h).to eq(30 => 'thirty')

        expect(h.delete(:'30')).to eq('thirty')
        expect(h.to_h).to eq({})

        expect(h.delete(:non_existing)).to eq(nil)
        expect(h.to_h).to eq({})
      end
    end
  end

  describe '#delete_if' do
    it 'returns self' do
      h = subject.new(a: 1, b: 2, c: { d: 'mension' })

      the_same_instance = h.delete_if do |key|
        subject.indifferentiate_keys(:a, 'b').include?(key)
      end
      expect(the_same_instance).to eq(h)
      h.c.d = 'another'
      expect(the_same_instance.c.d).to eq('another')
    end

    it 'with values only' do
      h = subject.new
      h.a = { gang: 1 }
      h.b = { gang: 2 }
      h.c = { gang: 3 }
      h.d = { gang: 4 }

      h.delete_if { |_key, value| value.gang > 2 }

      expect(h.to_h).to eq(a: { gang: 1 }, b: { gang: 2 })
      expect(h.c).to eq(nil)
      expect(h.d).to eq(nil)
    end

    it 'with keys only' do
      hash = { quick: 1, brown: 2, fox: 3, jumps: 4 }
      h = subject.new(hash)
      h.delete_if { |key| %w[quick fox].include?(key.to_s) }
      expect(h.to_h).to eq(brown: 2, jumps: 4)
      expect(h.quick).to eq(nil)
      expect(h.fox).to eq(nil)
    end

    it 'with keys and values' do
      hash = { red: :red, green: :green, blue: 'yellow' }
      h = subject.new(hash)
      h.delete_if { |key, value| key.to_s != value.to_s }
      expect(h.to_h).to eq(red: :red, green: :green)
      expect(h.blue).to eq(nil)
    end
  end

  describe '#reject' do
    it 'returns a copy hasher' do
      h = subject.new(a: 1, deep: { sea: 'skeleton' }, c: 3)

      result = h.reject { |key| key != :deep }
      expect(h.to_h).to eq(a: 1, deep: { sea: 'skeleton' }, c: 3)
      expect(result.to_h).to eq(deep: { sea: 'skeleton' })
      result.deep.sea = 'not really'
      expect(h.deep.sea).to eq('skeleton')
      h.deep.sea = 'avenue'
      expect(result.deep.sea).to eq('not really')
    end
  end

  describe '#keep_if' do
    it 'returns removed values' do
      h = subject.new(a: 1, b: 2, c: { d: 'mension' })

      the_same_instance = h.keep_if do |key|
        subject.indifferentiate_keys(:a, 'c').include?(key)
      end
      expect(the_same_instance).to eq(h)
      h.c.d = 'another'
      expect(the_same_instance.c.d).to eq('another')
    end

    it 'with values only' do
      h = subject.new
      h.a = { gang: 1 }
      h.b = { gang: 2 }
      h.c = { gang: 3 }
      h.d = { gang: 4 }

      h.keep_if { |_key, value| value.gang > 2 }

      expect(h.to_h).to eq(c: { gang: 3 }, d: { gang: 4 })
      expect(h.a).to eq(nil)
      expect(h.b).to eq(nil)
    end

    it 'with keys only' do
      hash = { quick: 1, brown: 2, fox: 3, jumps: 4 }
      h = subject.new(hash)
      h.keep_if { |key| %w[quick fox].include?(key.to_s) }
      expect(h.to_h).to eq(quick: 1, fox: 3)
      expect(h.brown).to eq(nil)
      expect(h.jumps).to eq(nil)
    end

    it 'with keys and values' do
      hash = { red: :red, green: :green, blue: 'yellow' }
      h = subject.new(hash)
      h.keep_if { |key, value| key.to_s != value.to_s }
      expect(h.to_h).to eq(blue: 'yellow')
      expect(h.red).to eq(nil)
      expect(h.green).to eq(nil)
    end
  end

  describe '#select' do
    it 'returns a copy hasher' do
      h = subject.new(a: 1, seismic: { defender: 99 }, c: 3)

      result = h.select { |_key, value| value.is_a?(subject) }
      expect(h.to_h).to eq(a: 1, seismic: { defender: 99 }, c: 3)
      expect(result.to_h).to eq(seismic: { defender: 99 })
      result.seismic.defender = 'aqua rythm'
      expect(h.seismic.defender).to eq(99)
      h.seismic.defender = 'exhibition'
      expect(result.seismic.defender).to eq('aqua rythm')
    end
  end

  describe '#merge' do
    context 'with `Hash`' do
      it 'returns a new merged instance' do
        h = subject.new(a: 1, b: { system: :rule }, c: 2)

        merged = h.merge(c: :uniq, b: { regex: /shallow/ })

        expect(merged.to_h).to eq(a: 1, c: :uniq, b: { regex: /shallow/ })
        expect(h.to_h).to eq(a: 1, b: { system: :rule }, c: 2)

        h.a = 2
        expect(merged.a).to eq(1)
      end
    end

    context 'with `Hasher`' do
      it 'returns a new merged instance' do
        h1 = subject.new(movies: [1, 2, 3], cast: [{ id: 9, name: 'Steve' }])
        h2 = subject.new(year: 1984)

        expected = {
          movies: [1, 2, 3],
          cast: [{ id: 9, name: 'Steve' }],
          year: 1984
        }
        merged = h1.merge(h2)
        expect(merged).to eq(expected)

        merged.year += 2
        expect(merged.year).to eq(1986)
        merged.movies = [4, 5, 6]
        expect(merged.movies).to eq([4, 5, 6])
        expect(h1.movies).to eq([1, 2, 3])
        expect(h2.movies).to eq(nil)
        expect(h1.year).to eq(nil)
        expect(h2.year).to eq(1984)
      end
    end
  end

  describe '#merge!' do
    context 'with `Hash`' do
      it 'success' do
        h = subject.new(a: 1, b: { hash: 'ff3s', '12' => 'old' })

        other = { c: :uniq, b: { also: 'uniq' }, 12 => 'twelve' }

        h.merge!(other)

        expect(h).to eq(a: 1, c: :uniq, b: { also: 'uniq' }, 12 => 'twelve')

        h.b = :different_value
        expect(other).to eq(c: :uniq, b: { also: 'uniq' }, 12 => 'twelve')
      end
    end

    context 'with `Hasher`' do
      it 'returns a new merged instance' do
        h1 = subject.new(a: 1, b: { 41 => 'sense' }, c: 'old', 3.8 => 's')
        h2 = subject.new(c: 'ci', '3.8' => 'd')

        h1.merge!(h2)

        expect(h1.to_h).to eq(a: 1, b: { 41 => 'sense' }, c: 'ci', 3.8 => 'd')
        expect(h2.to_h).to eq(c: 'ci', 3.8 => 'd')

        h1.c = { new: true }
        expect(h2.c).to eq('ci')
      end
    end
  end

  describe '#assoc' do
    it 'associates key with `nil`' do
      h = subject.new

      h.assoc('a', nil)
      expect(h.to_h).to eq(a: nil)
    end

    it 'associates key with hash' do
      h = subject.new

      h.assoc('a', no: { problem: { at: :all } })
      expect(h.to_h).to eq(a: { no: { problem: { at: :all } } })
      expect(h.a.no.problem.at).to eq(:all)
    end

    it 'associates key with hasher' do
      h = subject.new

      h.assoc('a', subject.new(no: { problem: { at: :all } }))
      expect(h.to_h).to eq(a: { no: { problem: { at: :all } } })
      expect(h.a.no.problem.at).to eq(:all)
    end
  end
end
