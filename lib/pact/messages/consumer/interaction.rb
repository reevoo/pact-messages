require 'pact/consumer_contract/interaction'

module Pact::Messages::Consumer
  class Interaction < Pact::Interaction

    def to_hash
      {
        description: description,
        provider_state: provider_state,
        response: response.to_hash
      }
    end

  end
end
