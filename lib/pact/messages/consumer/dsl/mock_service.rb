require 'pact/messages/consumer/contract_builder'
require 'pact/messages/consumer/contract_builders'
require 'pact/messages/consumer/world'

module Pact::Messages::Consumer::DSL
  class MockService
    extend Pact::DSL

    attr_accessor :port, :standalone, :verify, :provider_name, :consumer_name, :pact_specification_version

    def initialize name, consumer_name, provider_name
      @name = name
      @consumer_name = consumer_name
      @provider_name = provider_name
      @port = nil
      @standalone = false
      @verify = true
      @pact_specification_version = nil
    end

    dsl do
      def port port
        self.port = port
      end

      def standalone standalone
        self.standalone = standalone
      end

      def verify verify
        self.verify = verify
      end

      def pact_specification_version pact_specification_version
        self.pact_specification_version = pact_specification_version
      end
    end

    def finalize
      validate
      register_mock_service
      configure_consumer_contract_builder
    end

    private

    def validate
      raise "Please provide a port for service #{@name}" unless port
    end

    def register_mock_service
      unless standalone
        Pact::MockService::AppManager.instance.register_mock_service_for provider_name, "http://localhost:#{port}", mock_service_options
      end
    end

    def configure_consumer_contract_builder
      consumer_contract_builder = create_consumer_contract_builder
      create_consumer_contract_builders_method consumer_contract_builder
      setup_verification(consumer_contract_builder) if verify
      consumer_contract_builder
    end

    def create_consumer_contract_builder
      consumer_contract_builder_fields = {
        :consumer_name => consumer_name,
        :provider_name => provider_name,
        :pactfile_write_mode => Pact.configuration.pactfile_write_mode,
        :port => port,
        :pact_dir => Pact.configuration.pact_dir
      }
      Pact::Messages::Consumer::ContractBuilder.new consumer_contract_builder_fields
    end

    def setup_verification consumer_contract_builder
      Pact.configuration.add_provider_verification do | example_description |
        consumer_contract_builder.verify example_description
      end
    end

    # This makes the consumer_contract_builder available via a module method with the given identifier
    # as the method name.
    # I feel this should be defined somewhere else, but I'm not sure where
    def create_consumer_contract_builders_method consumer_contract_builder
      Pact::Messages::Consumer::ContractBuilders.send(:define_method, @name.to_sym) do
        consumer_contract_builder
      end
      Pact::Messages.consumer_world.add_consumer_contract_builder consumer_contract_builder
    end

    def mock_service_options
      { pact_specification_version: pact_specification_version }
    end
  end
end
