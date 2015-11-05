require_relative '../pact_helper'
require 'user_app/message_builder'

module UserApp
  describe MessageBuilder, pact: true do
    subject { described_class.build(subscribed_status) }

    describe '.build' do
      context 'subscribed' do
        let(:subscribed_status) { true }
        let(:user_contract) do
          Pact::Messages.get_response('Message Provider', 'Message Consumer', 'User subscribed')
        end

        it 'matches the contract' do
          diff = Pact::JsonDiffer.call(user_contract, subject)
          puts Pact::Matchers::UnixDiffFormatter.call(diff) if diff.any? # Print a pretty diff if we fail
          expect(diff).to be_empty
        end
      end

      context 'unsubscribed' do
        let(:subscribed_status) { false }
        let(:user_contract) do
          Pact::Messages.get_response('Message Provider', 'Message Consumer', 'User unsubscribed')
        end

        it 'matches the contract' do
          diff = Pact::JsonDiffer.call(user_contract, subject)
          puts Pact::Matchers::UnixDiffFormatter.call(diff) if diff.any? # Print a pretty diff if we fail
          expect(diff).to be_empty
        end
      end
    end
  end
end
