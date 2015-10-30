require 'net/http'
require 'pact/reification'
require 'pact/consumer_contract/interaction'

module Pact
  module Consumer
    class InteractionBuilder

      attr_reader :interaction

      def initialize &block
        @interaction = Interaction.new
        @callback = block
      end

      def given provider_state
        @interaction.provider_state = provider_state.nil? ? nil : provider_state.to_s
        self
      end

      def provide(response)
        interaction.response = Pact::Response.new(response)
        @callback.call interaction
        self
      end

    end
  end
end
