module Pact::Messages::Consumer::DSL
  class MessageConsumer
    extend Pact::DSL

    attr_accessor :consumer_name

    def initialize consumer_name
      @consumer_name = consumer_name
    end

    dsl do
      def has_pact_with provider_name, &block
        MessageProvider.build(provider_name, consumer_name, &block)
      end
    end

    def finalize
      validate
    end

    private

    def validate
      raise "Please provide a consumer name" unless (consumer_name && !consumer_name.empty?)
    end

  end
end
