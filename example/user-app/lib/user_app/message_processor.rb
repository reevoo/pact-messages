module UserApp
  # Message Processor
  module MessageProcessor
    def self.full_name(message)
      [message.fetch("first_name"), message.fetch("last_name")].join(" ")
    end
  end
end
