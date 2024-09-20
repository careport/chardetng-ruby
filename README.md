# CharDetNg

Character encoding detection using [chardetng](https://github.com/hsivonen/chardetng).

## Installation

Add to your application's Gemfile:
```ruby
gem "char_det_ng", git: "https://github.com/careport/chardetng-ruby"
```

And install with:
```bash
bundle install
```

## Usage

Create a detector, feed it data, and guess at the encoding:
```ruby
require "char_det_ng"

# Instantiate an EncodingDetector
detector = CharDetNg::EncodingDetector.new

# Feed it data
detector << File.read("/path/to/some/text/file")
# => true

# Guess the encoding, along with a boolean indicating
# whether the result is more likely than other encodings
detector.guess_and_assess
# => ["UTF-8", true]

# Or, if you just want the encoding:
detector.guess
# => "UTF-8"
```

There are also simple APIs for dealing with entire files:
```ruby
require "char_det_ng"

CharDetNg::EncodingDetector.guess_and_assess_file("/path/to/file")
# => ["WINDOWS-1252", true]
```

and IO objects:
```ruby
File.open("/path/to/file", mode: "rb") do |f|
  CharDetNg::EncodingDetector.guess_and_assess_io(f)
end
# => ["WINDOWS-1252", true]
```

The simple APIs read until EOF. If you want to guess without reading the
whole thing, you should instantiate a detector object and feed it data,
as in the first example.
