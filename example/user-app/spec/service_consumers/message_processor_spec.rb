require_relative '../pact_helper'
require 'user_app/message_processor'

module UserApp
  describe MessageProcessor, pact: true do
    let(:message) do
      Pact::Messages.get_response_sample('Message Provider', 'Message Consumer', 'User subscribed')
    end

    describe '.full_name' do
      it 'joins first name and last name' do
        expect(described_class.full_name(message)).to eq('John Smith')
      end
    end
  end
end
