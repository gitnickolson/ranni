# frozen_string_literal: true

module Features
  module Leveling
    module Text
      class TextLevelingManager
        COOLDOWN_LENGTH = 17

        def initialize(server_service:)
          @server_service = server_service
          @cooldown_list = []
          @cooldown_mutex = Mutex.new
        end

        def handle_message(user_id:, message_length:)
          return unless preferences_repository.text_leveling_enabled?
          return if user_on_cooldown?(user_id)

          update_user_level(user_id, message_length)
          start_cooldown_for_user(user_id)
        end

        private

        attr_reader :server_service, :cooldown_list, :cooldown_mutex

        def update_user_level(user_id, message_length)
          previous_level = text_levels_repository.find_by_user_id(user_id:)
          updated_level = text_levels_repository.update_xp(user_id:,
                                                           experience_points: random_xp_amount(message_length))

          return unless updated_level.numeric > previous_level.numeric

          level_up_manager.call(updated_level:)
        end

        def user_on_cooldown?(user_id)
          cooldown_mutex.synchronize { cooldown_list.include?(user_id) }
        end

        def start_cooldown_for_user(user_id)
          cooldown_mutex.synchronize do
            cooldown_list << user_id
          end

          Thread.new do
            sleep COOLDOWN_LENGTH
            cooldown_mutex.synchronize do
              cooldown_list.delete(user_id)
            end
          end
        end

        def random_xp_amount(message_length)
          return rand(15...40) if message_length < 150
          return rand(20...60) if message_length < 300

          rand(40...80)
        end

        def level_up_manager
          @level_up_manager ||= LevelUpManager.new(server_service:)
        end

        def text_levels_repository
          @text_levels_repository ||= Repositories::TextLevelsRepository.new(server_service:)
        end

        def preferences_repository
          @preferences_repository ||= Repositories::PreferencesRepository.new(server_id: server_service.server.id)
        end
      end
    end
  end
end
