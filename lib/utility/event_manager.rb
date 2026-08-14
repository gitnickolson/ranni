# frozen_string_literal: true

module Utility
  class EventManager
    def initialize(bot:)
      @bot = bot
    end

    def register_events
      Events::Welcome.listen(bot:)
    end

    private

    attr_reader :bot
  end
end
