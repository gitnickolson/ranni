# frozen_string_literal: true

module Utility
  class EventManager
    def initialize(bot:)
      @bot = bot
    end

    def register_global_events
      Events::Welcome.listen(bot:)
    end

    def register_server_specific_events(server_service:)
      birthday_celebration = Events::BirthdayCelebration.new(server_service:)
      birthday_celebration.call
    end

    private

    attr_reader :bot
  end
end
