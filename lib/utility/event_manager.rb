# frozen_string_literal: true

module Utility
  class EventManager
    def initialize(bot:)
      @bot = bot
    end

    def register_events
      Events::Welcome.listen(bot:)

      bot.servers.each_key do |server_id|
        server_service = Utility::ServerService.new(bot:, server_id:)

        birthday_celebration = Events::BirthdayCelebration.new(server_service:)
        birthday_celebration.call
      end
    end

    private

    attr_reader :bot
  end
end
