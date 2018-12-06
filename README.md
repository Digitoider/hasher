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

## Helpful methods

### `to_h`
Calling `to_h` on a `Hasher` returns a `Hash` that can be later turned into JSON. Let's try it out:
```ruby
songs = Hasher.new

songs.items = []
songs.items[0] = { id: 0, gang: 'Beatles' }
songs.items << { id: 1, gang: 'Wardruna' }
songs.items[2] = {}
songs.items[2].id = 2
songs.items[2].gang = 'The Chieftains'
songs.total = 3
songs.to_h
# =>
      {
        items: [
          { id: 0, gang: 'Beatles' },
          { id: 1, gang: 'Wardruna' }
          { id: 2, gang: 'The Chieftains' }
        ],
        total: 3
      }
```




