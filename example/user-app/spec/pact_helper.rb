require_relative 'spec_helper'
require 'pact/messages'

Pact.configure do | config |
  config.doc_generator = :markdown
end

Pact::Messages.service_consumer 'Message Consumer' do
  has_pact_with 'Message Provider' do
    mock_service 'message_provider_service'
  end
end

Pact::Messages.build_mock_service(:message_provider_service) do |service|
  service.given('User subscribed')
    .provide(
      {
        'first_name' => like('John'),
        'last_name'  => like('Smith'),
        'subscribed' => true,
      },
    )

  service.given('User unsubscribed')
    .provide(
      {
        'first_name' => like('John'),
        'last_name'  => like('Smith'),
        'subscribed' => false,
      },
    )
end
