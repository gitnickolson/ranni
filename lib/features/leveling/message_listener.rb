# frozen_string_literal: true

module Features
  module Leveling
    class MessageListener
      class << self
        def call(bot:, leveling_manager:)
          bot.message do |event|
            next if event.user.bot_account?

            leveling_manager.handle_message(
              user_id: event.user.id,
              message_length: event.message.content.length,
              server_id: event.server.id
            )
          end
        end
      end
    end
  end
end
