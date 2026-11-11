# frozen_string_literal: true

module Features
  module Leveling
    class VoiceLevelingManager
      FIFTEEN_MINUTES = 900
      MIN_LEVELING_USERS = 2

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
          rescue StandardError => e
            logger.error(message: "Voice XP loop error: #{e.class}: #{e.message}")
          end
        end
      end

      private

      attr_reader :bot, :voice_states, :voice_states_mutex

      def add_xp_to_users
        voice_states.each do |server_id, user_ids|
          server_service = Utility::ServerService.new(bot:, server_id:)

          next unless server_service.voice_leveling_enabled?

          user_ids.each do |user_id|
            next unless voice_member_count(user_id, server_service) >= MIN_LEVELING_USERS

            update_user_level(user_id, server_service)
          end
        end
      end

      def update_user_level(user_id, server_service)
        levels_repository = Repositories::LevelsRepository.new(server_service:)
        previous_level = levels_repository.find_or_create_by_user_id(user_id:)
        updated_level = levels_repository.update_xp(user_id:,
                                                    experience_points: calculate_experience_points(previous_level))

        return unless updated_level.numeric > previous_level.numeric

        level_up_manager = LevelUpManager.new(server_service:)
        level_up_manager.call(updated_level:)
      end

      def handle_action(user_id, server_id, action)
        case action
        when :join
          add_user_to_voice_state(user_id, server_id)
        when :leave
          remove_user_from_voice_state(user_id, server_id)
        end
      end

      def add_user_to_voice_state(user_id, server_id)
        users = voice_states[server_id] ||= []
        users << user_id unless users.include?(user_id)
      end

      def remove_user_from_voice_state(user_id, server_id)
        users = voice_states[server_id]
        return if users.nil?

        users.delete(user_id)
        voice_states.delete(server_id) if users.empty?
      end

      def calculate_experience_points(level)
        random_xp_amount * level.multiplier
      end

      def voice_member_count(user_id, server_service)
        user_voice_channel = server_service.server.voice_channels.find do |channel|
          channel.users.map(&:id).include?(user_id)
        end

        user_voice_channel.users.count
      end

      def random_xp_amount
        rand(5...100)
      end

      def logger
        @logger ||= Utility::Logger.instance
      end
    end
  end
end
