require 'pact/messages/consumer'
require 'pact/messages/consumer/spec_hooks'
require 'pact/rspec'
require 'pact/helpers'

module Pact::Messages::Consumer
  module RSpec
    include Pact::Messages::Consumer::ContractBuilders
    include Pact::Helpers
  end
end

hooks = Pact::Messages::Consumer::SpecHooks.new

RSpec.configure do |config|
  config.include Pact::Messages::Consumer::RSpec

  config.before :all
    hooks.before_all
  end

  config.before :each, :pact => true do |example|
    hooks.before_each Pact::RSpec.full_description(example)
  end

  config.after :each, :pact => true do |example|
    hooks.after_each Pact::RSpec.full_description(example)
  end

  config.after :suite do
    hooks.after_suite
  end
end
