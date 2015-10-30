require 'uri'
require 'json/add/regexp'
require 'pact/logging'
require 'pact/mock_service/client'
require 'pact/consumer/interaction_builder'

module Pact::Messages::Consumer
  class ContractBuilder

    include Pact::Logging

    attr_reader :consumer_contract, :mock_service_base_url

    def initialize(attributes)
      @interaction_builder       = nil
      @consumer_contract_details = {
        consumer:            { name: attributes[:consumer_name] },
        provider:            { name: attributes[:provider_name] },
        pactfile_write_mode: attributes[:pactfile_write_mode].to_s,
        pact_dir:            attributes.fetch(:pact_dir)
      }
    end

    def given(provider_state)
      interaction_builder.given(provider_state)
    end

    def upon_receiving(description)
      interaction_builder.upon_receiving(description)
    end

    def verify example_description
      mock_service_client.verify example_description
    end

    def log msg
      mock_service_client.log msg
    end

    def write_pact
      mock_service_client.write_pact @consumer_contract_details
    end

    def wait_for_interactions options = {}
      wait_max_seconds = options.fetch(:wait_max_seconds, 3)
      poll_interval    = options.fetch(:poll_interval, 0.1)
      mock_service_client.wait_for_interactions wait_max_seconds, poll_interval
    end

    def handle_interaction_fully_defined interaction
      mock_service_client.add_expected_interaction interaction #TODO: What will happen if duplicate added?
      self.interaction_builder = nil
    end

    private

    attr_reader :mock_service_client
    attr_writer :interaction_builder

    def interaction_builder
      @interaction_builder ||=
        begin
          interaction_builder = InteractionBuilder.new do |interaction|
            self.handle_interaction_fully_defined(interaction)
          end
          interaction_builder
        end
    end
  end
end
