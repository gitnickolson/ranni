# frozen_string_literal: true

module Features
  module Leveling
    class VoiceStatusListener
      class << self
        def call(bot:, voice_leveling_manager:)
          bot.voice_state_update do |event|
            next if event.user.bot_account?

            voice_leveling_manager.change_user_voice_state(user_id: event.user.id,
                                                           server_id: event.server.id,
                                                           action: action_for_event(event))
          end
        end

        private

        def action_for_event(event)
          if event.old_channel.nil?
            :join
          elsif event.channel.nil?
            :leave
          else
            :client_state_change
          end
        end
      end
    end
  end
end
