require 'pact/doc/generate'
require 'pact/messages/consumer/world'

module Pact::Messages::Consumer
  class SpecHooks

    def before_all
      # Pact::MockService::AppManager.instance.spawn_all
      FileUtils.mkdir_p Pact.configuration.pact_dir
    end

    def before_each example_description
      Pact.messages_consumer_world.register_pact_example_ran
      # Pact.configuration.logger.info "Clearing all expectations"
      # Pact::MockService::AppManager.instance.ports_of_mock_services.each do |port|
      #   Pact::MockService::Client.clear_interactions port, example_description
      # end
    end

    def after_each example_description
      # Pact.configuration.logger.info "Verifying interactions for #{example_description}"
      # Pact.configuration.provider_verifications.each do |provider_verification|
      #   provider_verification.call example_description
      # end
    end

    def after_suite
      if Pact.messages_consumer_world.any_pact_examples_ran?
        Pact.messages_consumer_world.consumer_contract_builders.each { |c| c.write_pact }
        Pact::Doc::Generate.call
        # Pact::MockService::AppManager.instance.kill_all
        # Pact::MockService::AppManager.instance.clear_all
      end
    end
  end
end
