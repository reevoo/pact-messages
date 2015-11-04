module Pact::Messages
  module Consumer
  end
end

require_relative 'consumer/contract_builder'
require_relative 'consumer/interaction'
require_relative 'consumer/interaction_builder'
require_relative 'consumer/mock_service_factory'
require_relative 'consumer/world'
require_relative 'consumer/dsl'
