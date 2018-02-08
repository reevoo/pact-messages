require "spec_helper"
require "rake"
require "fileutils"

describe "Mock service definition" do
  let(:pact_dir) { File.join(Rake.application.original_dir, "tmp") }
  let(:world) { Pact::Messages::Consumer::World.new }
  let(:contract_builder) do
    Pact::Messages::Consumer::ContractBuilder.new(
      consumer_name: "My Consumer",
      provider_name: "My Provider",
      pact_dir: pact_dir,
    )
  end

  before do
    allow(Pact::Messages).to receive(:consumer_world).and_return(world)
    world.register_mock_service(:my_service, contract_builder)

    Pact::Messages.build_mock_service(:my_service) do |service|
      service
        .given("provider state 1")
        .provide(foo: like("bar1"))
        .given("provider state 2")
        .provide(foo: like("bar2"))
        .given("provider state 3")
        .description("description for 3")
        .provide(foo: like("bar3"))

      service.provide(foo: like("default bar"))
    end
  end

  it "provides way to get message specifications" do
    match_response = match(foo: instance_of(Pact::SomethingLike))
    expect(Pact::Messages.get_message_contract("My Provider", "My Consumer")).to match_response
    expect(Pact::Messages.get_message_contract("My Provider", "My Consumer", "provider state 1")).to match_response
    expect(Pact::Messages.get_message_contract("My Provider", "My Consumer", "provider state 2")).to match_response
    expect(Pact::Messages.get_message_contract("My Provider", "My Consumer", "provider state 3")).to match_response
  end

  it "provides way to get messages" do
    expect(Pact::Messages.get_message_sample("My Provider", "My Consumer")).to eq(foo: "default bar")
    expect(Pact::Messages.get_message_sample("My Provider", "My Consumer", "provider state 1")).to eq(foo: "bar1")
    expect(Pact::Messages.get_message_sample("My Provider", "My Consumer", "provider state 2")).to eq(foo: "bar2")
    expect(Pact::Messages.get_message_sample("My Provider", "My Consumer", "provider state 3")).to eq(foo: "bar3")
  end

  it "generates a pact json file" do
    generated_file = File.join(pact_dir, "my_consumer-my_provider.json")
    expected_file = File.join(Rake.application.original_dir, "spec", "fixture", "my_consumer-my_provider.json")
    expect(File.exist?(generated_file)).to eq(true)
    expect(FileUtils.compare_file(generated_file, expected_file)).to eq(true)
  end
end
