require 'net/http'
require 'uri'
require 'pact'

module Pact::Messages
  module ContractRepository
    module_function

    def get_contract(provider_name, consumer_name)
      # search for it locally, if not found look on the pack broker
      Pact::Messages.consumer_world.find_contract(provider_name, consumer_name) ||
        Pact::ConsumerContract.from_uri(pact_broker_url(provider_name, consumer_name))
    end

    def get_message_spec(provider_name, consumer_name, provider_state = nil)
      contract = get_contract(provider_name, consumer_name)
      fail "Contract between #{provider_name} and #{consumer_name} not found" unless contract
      find_response_for_provider_state(contract.interactions, provider_state)
    end

    def get_message(provider_name, consumer_name, provider_state = nil)
      Pact::Reification.from_term(get_message_spec(provider_name, consumer_name, provider_state))
    end

    def pact_broker_url(provider, consumer)
      url = URI.encode("/pacts/provider/#{provider}/consumer/#{consumer}/")
      URI(ENV.fetch('PACT_BROKER_URL') + url + 'latest')
    end

    def find_response_for_provider_state(interactions, state)
      interaction = interactions.find { |i| i.provider_state == state }
      fail "State #{state} not found among interaction states #{interactions.map(&:provider_state)}" unless interaction
      interaction.response[:body]
    end
  end
end
