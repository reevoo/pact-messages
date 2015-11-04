require 'pact'

module Pact
  module Messages
  end
end

require 'pact/messages/consumer'
require 'pact/messages/provider'

Pact.send(:extend, Pact::Messages::Consumer::DSL)
