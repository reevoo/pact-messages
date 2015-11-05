require_relative '../spec_helper'
require 'pact/messages'

Pact.configure do | config |
  config.doc_generator = :markdown
end

Pact::Messages.service_consumer 'Message Consumer' do
  has_pact_with 'Message Provider' do
    mock_service 'message_provider_service' do
      pact_specification_version '0.0.1'
    end
  end
end
