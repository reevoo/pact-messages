require 'spec_helper'

describe 'Consumer side configuration' do
  let(:world) { Pact::Messages::Consumer::World.new }

  before do
    allow(Pact::Messages).to receive(:consumer_world).and_return(world)

    Pact::Messages.service_consumer 'My Consumer' do
      has_pact_with 'My Service' do
        mock_service :my_service
      end

      has_pact_with 'My Other Service' do
        mock_service :my_other_service do
          pact_specification_version '1.2.3'
        end
      end
    end
  end

  it 'registers the mock services' do
    expect(world.mock_services.keys).to contain_exactly(:my_service, :my_other_service)
  end

  it 'creates the contract builders' do
    contract_builder = world.find_contract_builder(:my_service)
    expect(contract_builder).to be_instance_of(Pact::Messages::Consumer::ContractBuilder)
    expect(contract_builder.consumer_name).to eq('My Consumer')
    expect(contract_builder.provider_name).to eq('My Service')

    contract_builder = world.find_contract_builder(:my_other_service)
    expect(contract_builder).to be_instance_of(Pact::Messages::Consumer::ContractBuilder)
    expect(contract_builder.consumer_name).to eq('My Consumer')
    expect(contract_builder.provider_name).to eq('My Other Service')
  end
end
