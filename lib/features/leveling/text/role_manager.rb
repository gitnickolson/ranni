# frozen_string_literal: true

module Features
  module Leveling
    module Text
      class RoleManager
        def initialize(server_service:)
          @server_service = server_service
        end

        def handle_rank_up(updated_level:, next_rank:)
          member = server_service.member_from(identifier: updated_level.user_id)
          next_role = roles_repository.role_from_id(role_id: next_rank.role_id)

          member.add_role(next_role)

          previous_rank = ranks_repository.previous_rank_for(rank: next_rank)
          return if previous_rank.nil?

          previous_role = roles_repository.role_from_id(role_id: previous_rank.role_id)
          member.remove_role(previous_role) if member.role?(previous_role)
        end

        private

        attr_reader :server_service

        def roles_repository
          @roles_repository ||= Repositories::RolesRepository.new(server_service:)
        end

        def ranks_repository
          @ranks_repository ||= Repositories::RanksRepository.new(server_service:)
        end
      end
    end
  end
end
