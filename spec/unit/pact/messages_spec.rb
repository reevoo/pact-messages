require "spec_helper"

describe Pact::Messages do
  it "has a version number" do
    expect(Pact::Messages::VERSION).not_to be nil
  end
end
