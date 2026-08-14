# frozen_string_literal: true

module Features
  module Leveling
    module Text
      class MessageListener
        class << self
          def call(bot:, text_leveling_manager:)
            bot.message do |event|
              next if event.user.bot_account?

              text_leveling_manager.handle_message(
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
end
