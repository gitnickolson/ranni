# frozen_string_literal: true

module Features
  module Leveling
    class LevelUpCongratulator
      include Translations::Translatable

      def initialize(server_service:)
        @server_service = server_service
      end

      def call(updated_level:, next_rank: nil)
        congratulation_channel = server_service.level_up_congratulation_channel
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
            { member_mention: member.mention, level_numeric: updated_level.numeric, role: new_role.name })
        end
      end

      def roles_repository
        @roles_repository ||= Repositories::RolesRepository.new(server_service:)
      end
    end
  end
end
