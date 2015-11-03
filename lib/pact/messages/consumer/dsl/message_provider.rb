require 'pact/shared/dsl'
require_relative 'mock_service'

module Pact::Messages::Consumer::DSL
  class MessageProvider
    extend Pact::DSL

    attr_accessor :service, :consumer_name, :provider_name

    def initialize provider_name, consumer_name
      @provider_name = provider_name
      @consumer_name = consumer_name
      @service = nil
    end

    dsl do
      def mock_service name, &block
        self.service = MockService.build(name, consumer_name, provider_name, &block || proc {})
      end
    end

    def finalize
      validate
    end

    private

    def validate
      raise "Please configure a service for #{provider_name}" unless service
    end

  end

end
