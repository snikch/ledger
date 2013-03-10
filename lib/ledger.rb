require "ledger/version"
require 'ledger/event'
require 'ledger/has_events'
require 'ledger/creates_events'

module Ledger
  mattr_accessor :event_scope_method, :event_actor_method, :redis

  @@event_scope_method = :current_account
  @@event_actor_method = :current_user
  @@redis = $redis

  class << self
    def configure
      yield self
    end
  end
end
