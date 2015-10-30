# Pact::Messages

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/pact/messages`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'pact-messages'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pact-messages

## Usage


Setup

```ruby
Pact.message_consumer 'Message Consumer' do
  has_pact_with 'Message Provider' do
    mock_service 'mock_1' do
      pact_specification_version '0.0.1'
    end
  end
end
```


Usage

```ruby
mock_1.given('a Purchaser with ID 4114114')
    .provide(
      {
       'id'             => like(4_114_114),
       'first_name'     => like('Andreas'),
       'unsubscribed'   => like(false),
       'anonymous'      => like(false),
      },
    )
    
mock_1.given('a Purchaser with ID 4114114 does not exist')
    .provide(
      {
       'id'             => like(nil),
       'first_name'     => like('Andreas'),
       'unsubscribed'   => like(false),
       'anonymous'      => like(false),
      },
    )
    
    

```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/pact-messages. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).



