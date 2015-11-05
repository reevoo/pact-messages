require 'pact'

module Pact
  module Messages
    module_function

    def build_mock_service(mock_service_name, &block)
      Pact::Messages::Consumer::MockServiceFactory.build(mock_service_name, &block)
    end

    def get_contract(provider_name, consumer_name)
      Pact::Messages::ContractRepository.get_contract(provider_name, consumer_name)
    end

    def get_interaction_response(provider_name, consumer_name, provider_state = nil, options = {})
      Pact::Messages::ContractRepository.get_interaction_response(provider_name, consumer_name, provider_state, options)
    end
  end
end

require 'pact/messages/consumer'
require 'pact/messages/provider'
require 'pact/messages/contract_repository'

Pact::Messages.send(:extend, Pact::Messages::Consumer::DSL)
