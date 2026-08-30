# frozen_string_literal: true

module Features
  module Leveling
    class VoiceLevelingManager
      FIFTEEN_MINUTES = 900

      def initialize(bot:)
        @bot = bot
        @voice_states = {}
        @voice_states_mutex = Mutex.new
      end

      def add_voice_users(user_ids:, server_id:)
        voice_states_mutex.synchronize { voice_states[server_id] = user_ids }
      end

      def change_user_voice_state(user_id:, server_id:, action:)
        return if action == :client_state_change

        voice_states_mutex.synchronize do
          handle_action(user_id, server_id, action)
        end
      end

      def start_xp_loop
        Thread.new do
          loop do
            sleep FIFTEEN_MINUTES
            next unless voice_states.any? { |_, user_ids| user_ids.any? }

            voice_states_mutex.synchronize { add_xp_to_users }
          end
        rescue StandardError => e
          logger.error(message: "Voice XP loop error: #{e.class}: #{e.message}")
        end
      end

      private

      attr_reader :bot, :voice_states, :voice_states_mutex

      def add_xp_to_users
        voice_states.each do |server_id, user_ids|
          server_service = Utility::ServerService.new(bot:, server_id:)

          next unless server_service.voice_leveling_enabled?

          user_ids.each do |user_id|
            update_user_level(user_id, server_service)
          end
        end
      end

      def update_user_level(user_id, server_service)
        levels_repository = Repositories::LevelsRepository.new(server_service:)
        previous_level = levels_repository.find_by_user_id(user_id:)
        updated_level = levels_repository.update_xp(user_id:,
                                                    experience_points: random_xp_amount)

        return unless updated_level.numeric > previous_level.numeric

        level_up_manager = LevelUpManager.new(server_service:)
        level_up_manager.call(updated_level:)
      end

      def handle_action(user_id, server_id, action)
        case action
        when :join
          users = voice_states[server_id]
          users.nil? ? voice_states[server_id] = [user_id] : voice_states[server_id] << user_id
        when :leave
          voice_states[server_id]&.delete(user_id)
          voice_states.delete(server_id) if voice_states[server_id] && voice_states[server_id].empty?
        end
      end

      def random_xp_amount
        rand(10...200)
      end

      def logger
        @logger ||= Utility::Logger.instance
      end
    end
  end
end
