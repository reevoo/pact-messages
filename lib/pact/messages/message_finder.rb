require "net/http"
require "uri"
require "pact"

module Pact
  module Messages
    module MessageFinder
      @pact_broker_url = "http://pact-broker"

      module_function

      def pact_broker_url
        @pact_broker_url
      end

      def pact_broker_url=(url)
        @pact_broker_url = url
      end

      def get_message_contract(provider_name, consumer_name, provider_state = nil, contract_uri = nil)
        contract = get_contract(provider_name, consumer_name, contract_uri)
        fail "Contract between #{provider_name} and #{consumer_name} not found" unless contract
        find_response_for_provider_state(contract.interactions, provider_state)
      end

      def get_message_sample(provider_name, consumer_name, provider_state = nil, contract_uri = nil)
        Pact::Reification.from_term(get_message_contract(provider_name, consumer_name, provider_state, contract_uri))
      end

      class << self
        private

        def get_contract(provider_name, consumer_name, contract_uri = nil)
          # search for it locally, if not found look on the pack broker
          Pact::Messages.consumer_world.find_contract(provider_name, consumer_name) ||
            Pact::ConsumerContract.from_uri(contract_uri || pact_contract_uri(provider_name, consumer_name))
        end

        def pact_contract_uri(provider, consumer)
          path = URI.encode("pacts/provider/#{provider}/consumer/#{consumer}/latest")
          URI("#{pact_broker_url}/#{path}")
        end

        def find_response_for_provider_state(interactions, state)
          interaction = interactions.find { |i| i.provider_state == state }
          unless interaction
            fail "State #{state} not found among interaction states #{interactions.map(&:provider_state)}"
          end

          interaction.response[:body]
        end
      end
    end
  end
end
