module Pact
  module Messages
    module Consumer
      module DSL
        class MockService
          extend Pact::DSL

          attr_accessor :verify, :provider_name, :consumer_name

          def initialize(name, consumer_name, provider_name)
            @name          = name
            @consumer_name = consumer_name
            @provider_name = provider_name
            @verify        = true
          end

          dsl do
            def verify(verify)
              self.verify = verify
            end
          end

          def finalize
            contract_builder = create_consumer_contract_builder
            Pact::Messages.consumer_world.register_mock_service(@name.to_sym, contract_builder)
            setup_verification(contract_builder) if verify
            contract_builder
          end

          private

          def create_consumer_contract_builder
            consumer_contract_builder_fields = {
              consumer_name:       consumer_name,
              provider_name:       provider_name,
              pactfile_write_mode: Pact.configuration.pactfile_write_mode,
              pact_dir:            Pact.configuration.pact_dir,
            }
            Pact::Messages::Consumer::ContractBuilder.new consumer_contract_builder_fields
          end

          def setup_verification(consumer_contract_builder)
            Pact.configuration.add_provider_verification do |example_description|
              consumer_contract_builder.verify example_description
            end
          end
        end
      end
    end
  end
end
