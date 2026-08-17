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
      end

      private

      attr_reader :bot, :server_service
    end
  end
end
