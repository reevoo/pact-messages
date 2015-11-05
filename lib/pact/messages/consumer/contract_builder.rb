require 'uri'
require 'json/add/regexp'
require 'pact/logging'
require 'pact/consumer_contract'
require 'pact/mock_service/client'
require 'pact/consumer_contract/consumer_contract_writer'

module Pact::Messages::Consumer
  class ContractBuilder
    include Pact::Logging

    attr_reader :consumer_name, :provider_name

    def initialize(attributes)
      @consumer_name              = attributes.fetch(:consumer_name)
      @provider_name              = attributes.fetch(:provider_name)
      @consumer_contract_details  = {
        consumer:                   { name: @consumer_name },
        provider:                   { name: @provider_name },
        pactfile_write_mode:        attributes[:pactfile_write_mode].to_s,
        pact_dir:                   attributes.fetch(:pact_dir),
      }
      @interaction_builder        = nil
      @interactions               = []
    end

    def given(provider_state)
      interaction_builder.given(provider_state)
    end

    def provide(message)
      interaction_builder.provide(message)
    end

    def verify example_description
      true # TODO: find out how the verification works in original pact
    end

    def log(msg)
      logger.log(msg)
    end

    def write_pact
      consumer_contract_params = @consumer_contract_details.merge(interactions: @interactions)
      consumer_contract_writer = Pact::ConsumerContractWriter.new(consumer_contract_params, logger)
      consumer_contract_writer.write
    end

    def consumer_contract
      @consumer_contract ||= Pact::ConsumerContract.new(
        consumer: Pact::ServiceConsumer.new(name: @consumer_name),
        provider: Pact::ServiceProvider.new(name: @provider_name),
        interactions: @interactions
      )
    end

    def handle_interaction_fully_defined(interaction)
      @interactions << interaction
      @interaction_builder = nil
    end

    private

    attr_reader :mock_service_client
    attr_writer :interaction_builder

    def interaction_builder
      @interaction_builder ||=
        begin
          interaction_builder = InteractionBuilder.new do |interaction|
            self.handle_interaction_fully_defined(interaction)
            self
          end
          interaction_builder
        end
    end
  end
end
