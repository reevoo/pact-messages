require 'pact'
require 'pact/messages/consumer'
require 'pact/messages/message_finder'

module Pact
  module Messages
    module_function

    def service_consumer(name, &block)
      Pact::Messages::Consumer::DSL::MessageConsumer.build(name, &block)
    end

    def build_mock_service(mock_service_name, &block)
      Pact::Messages::Consumer::MockServiceFactory.build(mock_service_name, &block)
    end

    def get_message_contract(provider_name, consumer_name, provider_state = nil)
      Pact::Messages::MessageFinder.get_message_contract(provider_name, consumer_name, provider_state)
    end

    def get_message_sample(provider_name, consumer_name, provider_state = nil)
      Pact::Messages::MessageFinder.get_message_sample(provider_name, consumer_name, provider_state)
    end

    def pact_broker_url=(url)
      Pact::Messages::MessageFinder.pact_broker_url = url
    end
  end
end
