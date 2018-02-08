module Pact
  module Messages
    module Consumer
      module DSL
        class MessageConsumer
          extend Pact::DSL

          attr_accessor :consumer_name

          def initialize(consumer_name)
            @consumer_name = consumer_name
          end

          dsl do
            def has_pact_with(provider_name, &block) # rubocop:disable Style/PredicateName
              MessageProvider.build(provider_name, consumer_name, &block)
            end
          end

          def finalize
            validate
          end

          private

          def validate
            fail "Please provide a consumer name" unless consumer_name && !consumer_name.empty?
          end
        end
      end
    end
  end
end
