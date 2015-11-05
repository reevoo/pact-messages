require 'spec_helper'

describe 'Mock service definition' do
  let(:world) { Pact::Messages::Consumer::World.new }
  let(:contract_builder) do
    Pact::Messages::Consumer::ContractBuilder.new(
      consumer_name: 'My Consumer',
      provider_name: 'My Provider',
      pact_dir: '/tmp'
    )
  end

  before do
    allow(Pact::Messages).to receive(:consumer_world).and_return(world)
    world.register_mock_service(:my_service, contract_builder)

    Pact::Messages.build_mock_service(:my_service) do |service|
      service
        .given('provider state 1')
        .provide(foo: like('bar1'))
        .given('provider state 2')
        .provide(foo: like('bar2'))

      service.provide(foo: like('default bar'))
    end
  end

  it 'provides way to get message specifications' do
    match_response = match(foo: instance_of(Pact::SomethingLike))
    expect(Pact::Messages.get_message_spec('My Provider', 'My Consumer')).to match_response
    expect(Pact::Messages.get_message_spec('My Provider', 'My Consumer', 'provider state 1')).to match_response
    expect(Pact::Messages.get_message_spec('My Provider', 'My Consumer', 'provider state 2')).to match_response
  end

  it 'provides way to get messages' do
    expect(Pact::Messages.get_message('My Provider', 'My Consumer')).to eq(foo: 'default bar')
    expect(Pact::Messages.get_message('My Provider', 'My Consumer', 'provider state 1')).to eq(foo: 'bar1')
    expect(Pact::Messages.get_message('My Provider', 'My Consumer', 'provider state 2')).to eq(foo: 'bar2')
  end
end
