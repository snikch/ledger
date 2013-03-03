require 'nest'
module Ledger
  module HasEvents
    def rdb
      Nest.new(self.class.name.downcase)[to_param]
    end

    def self.rdb
      Nest.new(name, Ledger.redis)
    end

    def event_stream length = 10
      events.lrange(0, length).map do |json|
        Ledger::Event.from_json json
      end
    end

    def add_event event
      events.lpush event.to_json
    end

    def events
      rdb[:events]
    end
  end
end
