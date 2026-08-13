# frozen_string_literal: true

module Features
  module Leveling
    class LevelingInitializer
      def initialize(bot:, server_service:)
        @bot = bot
        @server_service = server_service
      end

      def call
        text_leveling_manager = Text::TextLevelingManager.new(server_service:)
        Text::MessageListener.call(bot:, text_leveling_manager:)
      end

      private

      attr_reader :bot, :server_service
    end
  end
end
