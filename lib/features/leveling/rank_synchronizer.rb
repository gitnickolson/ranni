# frozen_string_literal: true

module Features
  module Leveling
    class RankSynchronizer
      def initialize(server_service:)
        @server_service = server_service
      end

      def call(updated_level:)
        target_rank = ranks_repository.find_current_for_level(level: updated_level.numeric)

        member = server_service.member_from(identifier: updated_level.user_id)
        remove_redundant_rank_roles(member, target_rank)

        return if target_rank.nil? || member.role?(target_rank.role_id)

        member.add_role(target_rank.role_id)
      end

      private

      attr_reader :server_service

      def remove_redundant_rank_roles(member, target_rank)
        all_rank_role_ids = ranks_repository.all.map(&:role_id)

        all_rank_role_ids.each do |role_id|
          next if target_rank && role_id == target_rank.role_id

          member.role?(role_id) && member.remove_role(role_id)
        end
      end

      def ranks_repository
        @ranks_repository ||= Repositories::RanksRepository.new(server_service:)
      end
    end
  end
end
