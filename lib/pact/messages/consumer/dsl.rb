require_relative 'dsl/message_consumer'

module Pact::Messages::Consumer
  module DSL
    def message_consumer name, &block
      MessageConsumer.build(name, &block)
    end
  end
end
