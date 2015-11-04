module Pact::Messages::Consumer
  module MockServiceFactory
    module Scope
      extend Pact::Helpers
    end

    module_function

    def build(mock_service_name, &block)
      contract_builder = Pact::Messages.consumer_world.find_contract_builder(mock_service_name)
      Scope.module_exec(contract_builder, &block)
      contract_builder.write_pact
    end
  end
end
