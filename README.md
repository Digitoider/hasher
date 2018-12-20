![version: 1.1](https://img.shields.io/badge/version-1.1-green.svg)

# Hasher

Hasher is a ruby gem that allows you to work with Hash the javascript way. Wonder how? Just follow me...

## Installation

TODO: write how to install it

## Usage

To start using, simply write this:

```ruby
require 'hasher'

h = Hasher.new
```

### Assignings

With `Hasher` you can assign simple values and acess it the way that is more comfortable for you

#### Simple values:
```ruby
h = Hasher.new

h.a = 5
h.a     # => 5
h['a']  # => 5
h[:a]   # => 5
```

#### Arrays:
```ruby
h = Hasher.new

h.a = []
h.a << 7
h.push(8)
h.a     # => [7, 8]
h['a']  # => [7, 8]
h[:a]   # => [7, 8]
```

#### Hashes:
Assigning a `Hash` to a key will automatically transform it into `Hasher`. Later on you can access it just like in the javascript
```ruby
h = Hasher.new

h.pleasure = { is: { 'all' => 'mine' } }
h.pleasure.is.all       # => "mine"
```
If there is some sophistication hidden in you, it's possible to access values like this:
```ruby
h[:pleasure].is['all']  # => "mine"
```

#### Mixed
`Hasher` allows to assign arrays, that contain hashes, arrays, numbers and anything you desire inside of it:
```ruby
h = Hasher.new

h.wishes = [9, { come: { true: 'Yeaahh!' } }, [6], 'strings', :symbols]
h.wishes.first         # => 9
h.wishes[1].come.true  # => "Yeaahh!"
h.wishes[2][0]         # => 6
h.wishes[3]            # => "strings"
h.wishes[4]            # => :symbols
```

#### Numeric keys
There is an ability to assign and access values via numeric keys
```ruby
h = Hasher.new

h[18] = 'integer value'
h[18]                     # => "integer value"
h['18']                   # => "integer value"
h[:'18']                  # => "integer value"

h[21.33] = 'float value'
h[21.33]                  # => "float value"
h['21.33']                # => "float value"
h[:'21.33']               # => "float value"
```

#### Default
If there is no value associated with the key, it returns `nil`:
```ruby
h = Hasher.new

h.a  # => nil
h.b  # => nil
```

### Instantiation with `{}`
You can pass a `{}` as an argument to the `.new` method. It will turn the `Hash` into `Hasher`:


```ruby
info = {
  first_name: 'Tom',
  last_name:  'Grin'
  age: 21,
  siblings: [
    { sister:  'Lila' },
    { brother: 'Thomas' }
  ]
}

person = Hasher.new(info)

person.first_name           # => "Tom"
person.last_name            # => "Grin"
person.age                  # => 21
person.siblings[0].sister   # => "Lila"
person.siblings[1].brother  # => "Thomas"
```

### Instantiation with `[]`

```ruby

Hasher[]                   # => {}
Hasher[[:a, 1], ['b', 2]]  # => { a: 1, b: 2 }
```

## Helpful methods

### `to_h`
Calling `to_h` on a `Hasher` returns a `Hash` that can be later turned into JSON. Let's try it out:
```ruby
songs = Hasher.new

songs.items         =  []
songs.items[0]      =  { id: 0, gang: 'Beatles' }
songs.items         << { id: 1, gang: 'Wardruna' }
songs.items[2]      =  {}
songs.items[2].id   =  2
songs.items[2].gang =  'The Chieftains'
songs.total         =  3
songs.to_h
# =>
      {
        items: [
          { id: 0, gang: 'Beatles' },
          { id: 1, gang: 'Wardruna' },
          { id: 2, gang: 'The Chieftains' }
        ],
        total: 3
      }
```
_**Important!**_ Using `to_h` as a key. You can assign value to a `:to_h` key, but calling `to_h` on
an instance of a `Hasher` will return a `Hash` representation of a `Hasher` structure:
```ruby
h = Hasher.new

h.a    = 'This is :a key'
h.to_h = 'This is :to_h key'

h[:to_h]   # => "This is :to_h key"
h['to_h']  # => "This is :to_h key"
h.to_h     # => { a: "This is :a key", to_h: "This is :to_h key" }
```

### `dup`
Returns a copy of a `Hasher` instance:
```ruby
h = subject.new(story: { author: 'Missing Guy' })

copy = h.dup
copy == h                           # => true

copy.story.author = 'Teleporter'
h.story.author                      # => 'Missing Guy'

copy.mental_mood = 'is pretty good'
h.mental_mood                       # => nil
```
_**Important!**_ To access `dup` key on an instance of
a `Hasher` use `h[:dup]` or `h['dup']`


### `each`
Allows you to iterate through each `|key|` or `|key, value|` pair:
```ruby
h = Hasher.new(a: { id: 1 }, b: { id: 2 }, c: { id: 3 })

result = []

h.each { |key, value| result << "#{key}::#{value.id}" }

pp result    # => ["a::1", "b::2", "c::3"]
```

### `each_value`
Allows you to iterate through each `|value|`:
```ruby
h = Hasher.new(a: { id: 1 }, b: { id: 2 }, c: { id: 3 })

result = []

h.each_value { |value| result << value.id }

pp result    # => [1, 2, 3]
```

### `map`
Allows you to map through each `|key|` or `|key, value|` pair:
```ruby
h = Hasher.new(hello: 'world', mister: 'Jackson')

result = h.map { |key, value| "#{key}::#{value}" }

pp result    # => ["hello::world", "mister::Jackson"]
```
`map` also can be used as a key:
```ruby
h = Hasher.new

h.map = 'mapper'
h.map                                 # => 'mapper'
h.map { |key, value| [key, value] }   # => [[:map, 'mapper']]
```

### `key?(key)`
Returns *true* if an instance of a `Hasher` has such key
```ruby
h = Hasher.new(flowers: { are: 'beautiful' })

h.key?('flowers')     # => true
h.key?(:flowers)      # => true
h.key?(:are)          # => false
h.flowers.key?(:are)  # => true
h.flowers.key?('are') # => true
```

### `dig(*keys)`
Returns value if passed chain of keys exists. It does not metter whether you
use symbolic key or string or even numeric key:
```ruby
hash = {
  :magic => { happens: { all: { the: 'time' } } },
  4      => { 7.1 => 'int and float'}
}
h = Hasher.new(hash)

h.dig('magic', :happens, 'all', :the)     # => "time"
h.dig(4, 7.1)                             # => "int and float"
h.dig('4', 7.1)                           # => "int and float"
h.dig(4, '7.1')                           # => "int and float"
```

If passed chain of keys can't be resolved, the *nil* is returned:
```ruby
h = Hasher.new

h.dig(8, :there, 'is', :no, :such, 'key') # => nil
```

Stil, if you want to create key named `dig` with some value, you are able to
do that:
```ruby
h = Hasher.new

h.dig = 5
h.dig                   # => 5
h.dig('dig')            # => 5
h.dig('unknown', 'key') # => nil
```

### Comparison `==`
An instance of `Hasher` can be compared with another instance of `Hasher` or
even a `Hash`:

```ruby
hash = {
  gangs: [
    { id: 1 },
    { id: 2 },
    { id: 3 }
  ],
  total: 3
}
h1 = Hasher.new(hash)
h2 = Hasher.new(hash)
h1 == hash               # => true
h2 == hash               # => true
h1.gangs[0] == { id: 1 } # => true
h1 == h2                 # => true

h1.total = 4
h1 == h2                 # => false
```

### `delete(key)`
It removes value that matches any passed key. If such a key doesn't exist, it
returns *nil*:

```ruby
h = Hasher.new(a: 5, b: 7)

h.delete(:a)             # => 5
h.to_h                   # => { b: 7 }
h.delete('b')            # => 7
h.to_h                   # => {}
h.delete('non_existing') # => nil
```

As you just saw in the example above, method `delete` works with indifferent
keys. The same rule could be applied to numeric keys:

```ruby
h = Hasher.new

h[15]  = 'fifteen'
h[6.6] = 'six point six'
h[30]  = 'thirty'

h.delete(15)             # =>  'fifteen'
h.to_h                  # => { 6.6 => 'six point six', 30 => 'thirty' }

h.delete('6.6')          # => 'six point six'
h.to_h                   # => { 30 => 'thirty' }

h.delete(:'30')          # => 'thirty'
h.to_h                   # => {}

h.delete(:non_existing)  # => nil
h.to_h                   # => {}
```

You can use `delete` as a key in an instance of `Hasher`:
```ruby
h = Hasher.new

h.delete = 'no'
h.delete         # => "no"
```

### `delete_if`
Removes keys with values if a condition in the block returns *true*.
Returns self
```ruby
h = Hasher.new(red: :red, blue: :blue, green: 'not_green')

h.delete_if { |key, value| key.to_s == value.to_s }

h.to_h       # => { green: "not_green" }
h.red        # => nil
h.blue       # => nil
```
**Important!** Inside of a `Hasher` instance keys are being transformed
into their indifferent representations. See what happens when the comparison
of the keys goes down the road:
```ruby
h = Hasher.new(a: 1, b: 2, c: 3)

h.delete_if { |key| key == :a || key == 'b' }

h.to_h       # => { b: 2, c: 3 }
```
Using `Hasher.indifferentiate_keys` will solve the case above properly:
```ruby
h = subject.new(a: 1, b: 2, c: 3)

removed_values = h.delete_if do |key|
  subject.indifferentiate_keys(:a, 'b').include?(key)
end

pp removed_values   # => [1, 2]
```
Or simply try converting keys in the block with `.to_s` method.

More info can be found on `Hasher.indifferentiate_keys` section.

### `reject`
Returns a new `Hasher` instance consisting of elements for which the
block evaluates to *false*:
```ruby
h = Hasher.new(a: 1, deep: { sea: 'skeleton' }, c: 3)

result = h.reject { |key| key != :deep }

h.to_h                          # => { a: 1, deep: { sea: 'skeleton' }, c: 3 }
result.to_h                     # => { deep: { sea: 'skeleton' } }

result.deep.sea = 'not really'
h.deep.sea                      # => 'skeleton'

h.deep.sea = 'avenue'
result.deep.sea                 # => 'not really'
```

### `select`
Does the opposite of `reject`. Returns a new `Hasher` instance consisting of elements for which the
block evaluates to *true*:
```ruby
h = Hasher.new(a: 1, seismic: { defender: 99 }, c: 3)

result = h.select { |_key, value| value.is_a?(Hasher) }

h.to_h                                  # => { a: 1, seismic: { defender: 99 }, c: 3
result.to_h                             # => { seismic: { defender: 99 } }
result.seismic.defender = 'aqua rythm'

h.seismic.defender                      # => 99
h.seismic.defender = 'exhibition'

result.seismic.defender                 # => "aqua rythm"
```

### `keep_if`
Removes keys with values if a passed block evaluates to *false*.
Returns self
```ruby
h = Hasher.new(red: :red, blue: :blue, green: 'not_green')

h.keep_if { |key, value| key.to_s == value.to_s }

h.to_h       # => { red: :red, blue: :blue }
h.green      # => nil
```

### `merge(other)`
Returns a new instance of `Hasher`. `other` can be either an
instance of `Hash` or `Hasher`.
Down below you can see an example of merging with `Hash`:
```ruby
h = Hasher.new(a: 1, b: { system: :rule }, c: 2)

merged = h.merge(b: { regex: /shallow/ }, c: :the_universe)

merged.to_h # => { a: 1, b: { regex: /shallow/ }, c: :the_universe }
h.to_h      # => { a: 1, b: { system: :rule }, c: 2 }

h.a = 2
merged.a    # => 1
```

Merging with `Hasher`:
```ruby
h1 = Hasher.new(movies: [1, 2, 3], cast: [{ id: 9, name: 'Steve' }])
h2 = Hasher.new(year: 1984)

merged = h1.merge(h2)
merged
# =>    {
#         movies: [1, 2, 3],
#         cast: [{ id: 9, name: 'Steve' }],
#         year: 1984
#       }

merged.year += 2
merged.year                # => 1986
h1.year                    # => nil
h2.year                    # => 1984

merged.movies = [4, 5, 6]
merged.movies              # => [4, 5, 6]
h1.movies                  # => [1, 2, 3]
h2.movies                  # => nil
```

## Class methods

### `Hasher.indifferentiate_keys(*keys)`
Returns an array of keys as they are stored in `Hasher`'s inner structure:
```ruby
Hasher.indifferentiate_keys(:a, 'b', :'c', 'd e')
# => [:a, :b, :c, "d e"]

Hasher.indifferentiate_keys(4.5, 3, '6', '1.8', :'17.4')
# => ['4.5', '3', '6', '1.8', '17.4']

Hasher.indifferentiate_keys
# => []
```

### `Hasher.indifferentiate_key(key)`
Returns a key as it would be stored in `Hasher`'s inner structure:
```ruby
Hasher.indifferentiate_key(:a)  # => :a
Hasher.indifferentiate_key('a') # => :a
Hasher.indifferentiate_key(4.5) # => "4.5"
Hasher.indifferentiate_key('8') # => "8"
```


# Configuration thoughts

When `config.strict_comparison = true`:
```ruby
h = Hasher.new(a: 1, b: 2, 36   => 'thirty six')

h == { a:     1, b: 2, 36   => 'thirty six' }   # => true
h == { 'a' => 1, b: 2, 36   => 'thirty six' }   # => false
h == { a:     1, b: 2, '36' => 'thirty six' }   # => false
```

When `config.strict_comparison = false`:
```ruby
h = Hasher.new(a: 1, b: 2, 36   => 'thirty six')

h == { a:     1, b: 2, 36   => 'thirty six' }   # => true
h == { 'a' => 1, b: 2, 36   => 'thirty six' }   # => true
h == { a:     1, b: 2, '36' => 'thirty six' }   # => true
```
Or create method `#compare_signature(other)`


