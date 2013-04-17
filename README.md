# FakeZip

## Usage

```ruby
require 'fake_zip'

# create zip file with given file structure
FakeZip 'temp.zip', {dir1:[:f1,:f2],dir2:[:f3,{dir4:[:f4]}]}

# ensure it works
puts `unzip -l temp.zip | awk '{print $4}'`
===========================================
dir1/
dir2/
dir2/dir4/
dir1/f1
dir1/f2
dir2/f3
dir2/dir4/f4
```

## Installation

Add this line to your application's Gemfile:

    gem 'fake_zip'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fake_zip

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
