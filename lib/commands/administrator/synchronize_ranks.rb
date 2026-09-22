# frozen_string_literal: true

module Commands
  module Administrator
    class SynchronizeRanks < Command
      NAME = :synchronize_ranks
      DESCRIPTION = 'Synchronize all ranks on the server with the member levels'
      RATE_LIMIT_AVOIDANCE_TIME = 1

      private

      def command_action
        transmitter.response(event:, text: t('commands.administrator.synchronize_ranks.synchronizing'))

        synchronize_ranks

        transmitter.send_message(channel: event.channel,
                                 text: t('commands.administrator.synchronize_ranks.successfully_synchronized'))
      rescue StandardError => e
        logger.error(message: e.message)
        transmitter.send_message(channel: event.channel, text: t('commands.administrator.synchronize_ranks.error'))
      end

      def synchronize_ranks
        rank_synchronizer = Utility::RankSynchronizer.new(server_service:)
        levels_repository = Repositories::LevelsRepository.new(server_service:)

        server_service.server.members.each do |member|
          next if member.bot_account?

          level = levels_repository.find_by_user_id(user_id: member.id)
          rank_synchronizer.call(level:)

          sleep RATE_LIMIT_AVOIDANCE_TIME
        end
      end
    end
  end
end
