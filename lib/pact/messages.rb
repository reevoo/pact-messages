require 'pact'

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
      Pact::Messages::ContractRepository.get_message_contract(provider_name, consumer_name, provider_state)
    end

    def get_message_sample(provider_name, consumer_name, provider_state = nil)
      Pact::Messages::ContractRepository.get_message_sample(provider_name, consumer_name, provider_state)
    end
  end
end

require 'pact/messages/consumer'
require 'pact/messages/contract_repository'
