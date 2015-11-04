require 'net/http'

module Pact::Messages::Consumer
  class InteractionBuilder

    attr_reader :interaction

    def initialize &block
      @interaction = Pact::Messages::Consumer::Interaction.new
      @interaction.request = Pact::Request::Expected.from_hash(method: 'MESSAGE', path: '/')
      @callback = block
    end

    def given provider_state
      interaction.provider_state = provider_state.nil? ? nil : provider_state.to_s
      self
    end

    def provide(response)
      interaction.response = Pact::Response.new(body: response)
      @callback.call interaction
      self
    end

  end
end
