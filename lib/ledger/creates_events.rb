# encoding: utf-8

module Ledger
  module CreatesEvents
    def create_event action, object, data = {}
      unless event_scope.respond_to? :add_event
        raise "#{Ledger.event_scope_method} does not respond to #add_event.
        Either include Ledger::HasEvents in that scope, or set the
        'event_scope_method' in your Ledger configuration to an
        object that does."
      end

      object_name = object.class.name == "String" ? \
        object : object.class.name.downcase

      details = {
        action: action,
        object: object_name,
        actor: {},
        data: data || {}
      }

      details[:data].merge! object.respond_to?(:event_details) ? \
        object.event_details : \
        { id: object.id, name: object.name }

      details[:actor].merge! event_actor.respond_to?(:event_details) ? \
        event_actor.event_details : \
        { id: event_actor.id, email: event_actor.email, name: event_actor.name }

      event_scope.add_event Ledger::Event.new(details)
    end

    def event_scope
      send(Ledger.event_scope_method)
    rescue NoMethodError
      raise "Hey, I tried calling #{Ledger.event_scope_method} but it doesn't exist. You’ll need to set the `event_scope_method` configuration value to the method that returns your current account object."
    end

    def event_actor
      send(Ledger.event_actor_method)
    rescue NoMethodError
      raise "Hey, I tried calling #{Ledger.event_scope_method} but it doesn't exist. You’ll need to set the `event_actor_method` configuration value to the method that returns your current user object."
    end
  end
end

