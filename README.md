# Pact::Messages

Define a pact contract between non-HTTP asynchronous service consumers and providers, enabling "consumer driven contract" testing.
                                                           
This is an extension for [Pact gem](https://github.com/realestate-com-au/pact "Pact") which covers HTTP scenario.
                                                               
This allows testing shape of your JSON messages on both sides of an integration point using fast unit tests.

This gem is inspired by the concept of "Consumer driven contracts". See [this article](http://martinfowler.com/articles/consumerDrivenContracts.html) by Ian Robinson for more information. 

 
## What is it good for?

Pact is most valuable for designing and testing integrations where you (or your team/organisation/partner organisation) control the development of both the consumer and the provider, and the requirements of the consumer are going to be used to drive the features of the provider.

You can find this solution very useful for systems based on messaging platforms aimed at providing an integration and communication between various business components, e.g. [RabbitMQ messaging system](https://www.rabbitmq.com "RabbitMQ").


## How does it work?

1. In the specs for the provider facing code in the consumer project, expectations are set up on a mock service provider.
   
2. When the specs are run, the mock service stores pact contracts in the Contract Repository and writes contract in to a "pact" file. 

3. In specs you are able to get pact contract from Contract Repository and verify shape of you message against this contract.

4. You are also able to build a Sample Message from the contract, e.g. build JSON message like {foo: 'bar'} from the contract: {foo: like('bar')}.


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


### Define Pact contract

```ruby
# in /spec/service_providers/pact_helper.rb
# or 
# in /spec/support/pact_helper.rb

require 'pact/messages'

Pact::Messages.service_consumer 'Message Consumer' do
  has_pact_with 'Message Provider' do
    mock_service 'message_provider_service' do
      pact_specification_version '0.0.1'
    end
  end
end
```


### Define Mock Service

```ruby
Pact::Messages.build_mock_service(:message_provider_service) do |service|
  service.given('User subscribed')
    .provide(
      {
        'first_name' => like('John'),
        'last_name'  => like('Smith'),
        'subscribed' => like(true),
      },
    )
    
  service.given('User unsubscribed')
    .provide(
      {
        'first_name' => like('John'),
        'last_name'  => like('Smith'),
        'subscribed' => like(false),
      },
    )
end
```

PS: '.given' is optional, if you have only one state, you don't need to specify '.given'

```ruby
Pact::Messages.build_mock_service(:message_provider_service) do |service|
  service.provide(
    {
      'first_name' => like('John'),
      'last_name'  => like('Smith'),
      'subscribed' => like(true),
    }
  )
end 
```

### Rspec

## Verify contract
In case of using [Sneakers gem](https://github.com/jondot/sneakers) - RabbitMQ background processing framework for Ruby.

```ruby
  module MessageBuilder
    def self.build
      {
        'first_name' => 'William',
        'last_name'  => 'Taylor,
        'subscribed' => true,
      }
    end
  end
end
```

```ruby
describe MessageBuilder, pact:true do
  let(:user_contract) do
    Pact::Messages::ContractRepository.get_contract('Message Provider', 'Message Consumer', 'User subscribed')
  end
    
  it 'matches the contract' do
    message = described_class.build
    diff = Pact::JsonDiffer.call(user_contract, message)
    puts Pact::Matchers::UnixDiffFormatter.call(diff) if diff.any? # Print a pretty diff if we fail
    expect(diff).to be_empty
  end
end
```



## Using Sample from the Contract

```ruby
  class MessageProcessor
    def initialize(user)
      @user = user
    end
    
    def subscribed?
      @user.fetch('subscribed')
    end
  end
end
```

```ruby
describe MyTestClass, pact:true do
  describe 'user subscribed') do
    let(:user) do
      Pact::Messages::ContractRepository.get_contract('Message Provider', 'Message Consumer', 'User subscribed')
    end
    
    it '' do
      expect(described_class.new(user)).to be_truthy
    end
  end

  describe 'user unsubscribed') do
    let(:user) do
      Pact::Messages::ContractRepository.get_contract('Message Provider', 'Message Consumer', 'User unsubscribed')
    end
    
    it '' do
      expect(described_class.new(user)).to be_falsey
    end
  end
end
```

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).



