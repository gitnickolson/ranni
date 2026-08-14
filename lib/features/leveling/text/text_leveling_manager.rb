# frozen_string_literal: true

module Features
  module Leveling
    module Text
      class TextLevelingManager
        COOLDOWN_LENGTH = 17

        def initialize(bot:)
          @bot = bot
          @cooldown_list = []
          @cooldown_mutex = Mutex.new
        end

        def handle_message(user_id:, message_length:, server_id:)
          @server_service = Utility::ServerService.new(bot:, server_id:)

          return unless text_leveling_enabled?(server_id)
          return if user_on_cooldown?(user_id)

          update_user_level(user_id, message_length)
          start_cooldown_for_user(user_id)
        end

        private

        attr_reader :bot, :server_service, :cooldown_list, :cooldown_mutex

        def update_user_level(user_id, message_length)
          levels_repository = Repositories::TextLevelsRepository.new(server_service:)
          previous_level = levels_repository.find_by_user_id(user_id:)
          updated_level = levels_repository.update_xp(user_id:,
                                                      experience_points: random_xp_amount(message_length))

          return unless updated_level.numeric > previous_level.numeric

          level_up_manager = LevelUpManager.new(server_service:)
          level_up_manager.call(updated_level:)
        end

        def user_on_cooldown?(user_id)
          cooldown_mutex.synchronize { cooldown_list.include?(user_id) }
        end

        def start_cooldown_for_user(user_id)
          server_id = server_service.server_id

          cooldown_mutex.synchronize do
            cooldown_list << "#{server_id}:#{user_id}"
          end

          Thread.new do
            sleep COOLDOWN_LENGTH
            cooldown_mutex.synchronize do
              cooldown_list.delete("#{server_id}:#{user_id}")
            end
          end
        end

        def random_xp_amount(message_length)
          return rand(15...40) if message_length < 150
          return rand(20...60) if message_length < 300

          rand(40...80)
        end

        def text_leveling_enabled?(server_id)
          preferences_repository = Repositories::PreferencesRepository.new(server_id:)
          preferences_repository.text_leveling_enabled?
        end
      end
    end
  end
end
