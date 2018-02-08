require "spec_helper"

describe Pact::Messages::MessageFinder do
  include Pact::Helpers

  subject { Pact::Messages::MessageFinder }
  let(:world) { Pact::Messages.consumer_world }
  let(:provider_name) { "My provider" }
  let(:consumer_name) { "My consumer" }
  let(:provider_state) { "My provider state" }
  let(:message_contract) { { foo: like("bar") } }
  let(:message_sample) { { foo: "bar" } }
  let(:contract) { instance_double(Pact::ConsumerContract, interactions: [interaction]) }
  let(:interaction) do
    instance_double(Pact::Interaction, provider_state: provider_state, response: { body: message_contract })
  end
  let(:pact_contract_uri) do
    URI(URI.encode("http://pact-broker/pacts/provider/#{provider_name}/consumer/#{consumer_name}/latest"))
  end

  describe ".get_message_contract" do
    it "returns message contract when contract defined locally" do
      expect(world).to receive(:find_contract).with(provider_name, consumer_name).and_return(contract)
      expect(subject.get_message_contract(provider_name, consumer_name, provider_state)).to eq(message_contract)
    end

    it "returns message contract when found on a pact broker" do
      expect(world).to receive(:find_contract).with(provider_name, consumer_name).and_return(nil)
      expect(Pact::ConsumerContract).to receive(:from_uri).with(pact_contract_uri).and_return(contract)
      expect(subject.get_message_contract(provider_name, consumer_name, provider_state)).to eq(message_contract)
    end

    it "raise error when there is no interaction for specified provider state" do
      expect(world).to receive(:find_contract).with(provider_name, consumer_name).and_return(contract)
      expect { subject.get_message_contract(provider_name, consumer_name, "Other state") }.to raise_error
    end
  end

  describe ".get_message_sample" do
    it "returns message contract when contract defined locally" do
      expect(world).to receive(:find_contract).with(provider_name, consumer_name).and_return(contract)
      expect(subject.get_message_sample(provider_name, consumer_name, provider_state)).to eq(message_sample)
    end

    it "returns message contract when found on a pact broker" do
      expect(world).to receive(:find_contract).with(provider_name, consumer_name).and_return(nil)
      expect(Pact::ConsumerContract).to receive(:from_uri).with(pact_contract_uri).and_return(contract)
      expect(subject.get_message_sample(provider_name, consumer_name, provider_state)).to eq(message_sample)
    end

    it "raise error when there is no interaction for specified provider state" do
      expect(world).to receive(:find_contract).with(provider_name, consumer_name).and_return(contract)
      expect { subject.get_message_sample(provider_name, consumer_name, "Other state") }.to raise_error
    end
  end

  describe ".pact_broker_url" do
    let(:pact_contract_uri) do
      URI(URI.encode("http://my-pact-broker/pacts/provider/#{provider_name}/consumer/#{consumer_name}/latest"))
    end

    it "modifies the default pact broker url" do
      Pact::Messages::MessageFinder.pact_broker_url = "http://my-pact-broker"
      expect(world).to receive(:find_contract).with(provider_name, consumer_name).and_return(nil)
      expect(Pact::ConsumerContract).to receive(:from_uri).with(pact_contract_uri).and_return(contract)
      subject.get_message_contract(provider_name, consumer_name, provider_state)
    end
  end
end
