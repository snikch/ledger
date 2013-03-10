module Ledger
  class Event
    attr_accessor :actor, :action, :object, :data, :created_at

    def initialize opts
      opts.each do |attr, value|
        self.send("#{attr}=", value) if respond_to?("#{attr}=")
      end
    end

    class << self
      def from_json json
        require 'json'
        self.new JSON.parse json
      end
    end
  end
end
