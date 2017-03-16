require 'net/http'

module Pact
  module Messages
    module Consumer
      class InteractionBuilder
        attr_reader :interaction

        def initialize(&block)
          @interaction         = Pact::Messages::Consumer::Interaction.new
          @interaction.request = Pact::Request::Expected.from_hash(method: 'MESSAGE', path: '/')
          @callback            = block
        end

        def given(provider_state)
          interaction.provider_state = provider_state.nil? ? nil : provider_state.to_s
          self
        end

        def provide(response)
          interaction.response = Pact::Response.new(body: response)
          @callback.call interaction
        end

        def description(description)
          interaction.description = description.nil? ? nil : description.to_s
          self
        end
      end
    end
  end
end
