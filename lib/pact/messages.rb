require 'pact'

module Pact
  module Messages
    module_function

    def build_mock_service(mock_service_name, &block)
      Pact::Messages::Consumer::MockServiceFactory.build(mock_service_name, &block)
    end
  end
end

require 'pact/messages/consumer'
require 'pact/messages/provider'
require 'pact/messages/contract_repository'

Pact::Messages.send(:extend, Pact::Messages::Consumer::DSL)
