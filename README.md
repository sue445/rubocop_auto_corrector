# RubocopAutoCorrector

Run `rubocop --auto-correct && git commit` with each cop.

# Example
See https://github.com/sue445/rubocop_auto_corrector/pull/3/commits

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rubocop_auto_corrector'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rubocop_auto_corrector

## Usage
```bash
$ bundle exec rubocop_auto_corrector
```

## Help
```bash
$ bundle exec rubocop_auto_corrector --help
Usage: rubocop_auto_corrector [options]
        --auto-correct-count COUNT   Run `rubocop --auto-correct` and `git commit` for this number of times. (default. 2)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/sue445/rubocop_auto_corrector.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
