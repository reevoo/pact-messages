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

        def initialize
          @any_pact_examples_ran = false
        end

        def consumer_contract_builders
          @consumer_contract_builders ||= []
        end

        def add_consumer_contract_builder consumer_contract_builder
          consumer_contract_builders << consumer_contract_builder
        end

        def find_consumer_contract(provider_name, consumer_name)
          builder = consumer_contract_builders.find do |builder|
            builder.provider_name == provider_name && builder.consumer_name == consumer_name
          end
          builder.consumer_contract if builder
        end

        def register_pact_example_ran
          @any_pact_examples_ran = true
        end

        def any_pact_examples_ran?
          @any_pact_examples_ran
        end

      end
    end
  end
end
