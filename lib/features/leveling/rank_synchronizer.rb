# frozen_string_literal: true

module Features
  module Leveling
    class RankSynchronizer
      def initialize(server_service:)
        @server_service = server_service
      end

      def call(updated_level:)
        target_rank = ranks_repository.find_current_for_level(level: updated_level.numeric)

        role_manager.sync_rank(updated_level:, target_rank:)
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
