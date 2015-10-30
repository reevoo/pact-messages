require 'pact/messages/version'
require 'pact'

require_relative 'messages/consumer'
require_relative 'messages/provider'

require 'pact/configuration'

Pact.send(:extend, Pact::Messages::Consumer::DSL)

module Pact
  module Messages

  end
end
