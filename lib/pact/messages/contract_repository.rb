require 'net/http'
require 'uri'
require 'pact'
# require 'pact/messages'

module Pact::Messages
  module ContractRepository
    module_function

    def get_contract(provider_name, consumer_name, provider_state = nil, options = {})
      # search for it localy, if not found look on the pack broker
      contract = Pact::Messages.consumer_world.find_contract(provider_name, consumer_name) ||
        Pact::ConsumerContract.from_uri(pact_path(provider_name, consumer_name))
      fail "Contract between #{provider_name} and #{consumer_name} not found" unless contract
      find_response_for_provider_state(contract.interactions, provider_state, options)
    end

    def default_contract_options
      { reificate: true }
    end

    def pact_path(provider, consumer)
      url = URI.encode("/pacts/provider/#{provider}/consumer/#{consumer}/")
      URI(ENV.fetch('PACT_BROKER_URL') + url + 'latest')
    end

    def find_response_for_provider_state(interactions, state, options = {})
      options.reverse_merge!(default_contract_options)
      interaction = interactions.select { |i| i.provider_state == state }.first
      body = interaction.response[:body]
      options[:reificate] ? ::Pact::Reification.from_term(body) : body
    end
  end
end
