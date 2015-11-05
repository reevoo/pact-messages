module UserApp
  module MessageBuilder
    def self.build(subscribed)
      {
        'first_name' => 'William',
        'last_name'  => 'Taylor',
        'subscribed' => subscribed,
      }
    end
  end
end
