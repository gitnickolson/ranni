# frozen_string_literal: true

module Features
  module Leveling
    class LevelUpCongratulator
      include Translations::Translatable

      def initialize(server_service:)
        @server_service = server_service
      end

      def call(updated_level:, next_rank: nil)
        congratulation_channel_id = preferences_repository.level_up_congratulation_channel_id
        congratulation_channel = server_service.channel_from_id(channel_id: congratulation_channel_id)
        return if congratulation_channel.nil?

        message = build_congratulation_message(updated_level, next_rank)

        Utility::Messages::MessageTransmitter.send_message(channel: congratulation_channel, text: message)
      end

      private

      attr_reader :server_service

      def build_congratulation_message(updated_level, next_rank)
        member = server_service.member_from(identifier: updated_level.user_id)

        if next_rank.nil?
          t('level_up_congratulator.reached_next_rank',
            { member_mention: member.mention, level_numeric: updated_level.numeric })
        else
          new_role = roles_repository.role_from_id(role_id: next_rank.role_id)

          t('level_up_congratulator.reached_next_rank_with_role',
            { member_mention: member.mention, level_numeric: updated_level.numeric, role_mention: new_role.mention })
        end
      end

      def roles_repository
        @roles_repository ||= Repositories::RolesRepository.new(server_service:)
      end

      def preferences_repository
        @preferences_repository ||= Repositories::PreferencesRepository.new(server_id: server_service.server.id)
      end
    end
  end
end
