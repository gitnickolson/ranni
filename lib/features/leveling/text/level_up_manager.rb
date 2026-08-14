# frozen_string_literal: true

module Features
  module Leveling
    module Text
      class LevelUpManager
        def initialize(server_service:)
          @server_service = server_service
        end

        def call(updated_level:)
          next_rank = ranks_repository.find_by_level(required_level: updated_level.numeric)

          return if next_rank.nil?

          role_manager.handle_rank_up(updated_level:, next_rank:)
        end

        private

        attr_reader :server_service

        def role_manager
          @role_manager ||= RoleManager.new(server_service:)
        end

        def ranks_repository
          @ranks_repository ||= Repositories::RanksRepository.new(server_service:)
        end
      end
    end
  end
end
