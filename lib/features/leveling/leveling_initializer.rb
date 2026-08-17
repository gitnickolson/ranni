# frozen_string_literal: true

module Features
  module Leveling
    class LevelingInitializer
      def initialize(bot:)
        @bot = bot
      end

      def call
        text_leveling_manager = TextLevelingManager.new(bot:)
        MessageListener.call(bot:, text_leveling_manager:)

        voice_leveling_manager = VoiceLevelingManager.new(bot:)
        VoiceStatusListener.call(bot:, voice_leveling_manager:)

        register_current_voice_users(voice_leveling_manager)

        voice_leveling_manager.start_xp_loop
      end

      private

      def register_current_voice_users(voice_leveling_manager)
        bot.servers.each_value do |server|
          voice_users = server.voice_channels.flat_map(&:users)

          next if voice_users.empty?

          voice_leveling_manager.add_voice_users(user_ids: voice_users.map(&:id), server_id: server.id)
        end
      end

      attr_reader :bot
    end
  end
end
