module Pact
  module Messages
    def self.consumer_world
      @consumer_world ||= Pact::Messages::Consumer::World.new
    end

    # internal api, for testing only
    def self.clear_consumer_world
      @consumer_world = nil
    end

    def self.logger
      @logger ||= Logger.new(STDOUT)
    end

    module Consumer
      class World
        attr_reader :mock_services

        def initialize
          @mock_services = {}
        end

        def register_mock_service(mock_service_name, contract_builder)
          mock_services[mock_service_name] = contract_builder
        end

        def find_contract_builder(mock_service_name)
          mock_services[mock_service_name]
        end

        def find_contract(provider_name, consumer_name)
          contract_builder = mock_services.values.find do |builder|
            builder.provider_name == provider_name && builder.consumer_name == consumer_name
          end
          contract_builder.consumer_contract if contract_builder
        end

      end
    end
  end
end
