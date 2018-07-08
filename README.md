# Trashy

Trashy let's you soft-delete Active Record models with ease.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'trashy'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install trashy

## Usage

Create a `deleted_at` column of type `datetime` on your model and `include
Trashy` in it. Then, to soft-delete a record, call `#trash` instead of
`#destroy` and that's it!

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
