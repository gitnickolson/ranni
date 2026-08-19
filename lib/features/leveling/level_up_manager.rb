# frozen_string_literal: true

module Features
  module Leveling
    class LevelUpManager
      def initialize(server_service:)
        @server_service = server_service
      end

      def call(updated_level:)
        next_rank = ranks_repository.find_by_level(required_level: updated_level.numeric)

        rank_synchronizer.call(level: updated_level)
        level_up_congratulator.call(updated_level:, next_rank:)
      end

      private

      attr_reader :server_service

      def rank_synchronizer
        @rank_synchronizer ||= Utility::RankSynchronizer.new(server_service:)
      end

      def level_up_congratulator
        @level_up_congratulator ||= LevelUpCongratulator.new(server_service:)
      end

      def ranks_repository
        @ranks_repository ||= Repositories::RanksRepository.new(server_service:)
      end
    end
  end
end
