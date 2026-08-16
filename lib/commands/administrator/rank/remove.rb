# frozen_string_literal: true

module Commands
  module Administrator
    module Rank
      class Remove < Subcommand
        NAME = :remove
        DESCRIPTION = 'Remove a rank'
        PARAMETERS = [{ type: :role, name: :role, required: true,
                        description: 'Choose the role that should be removed from ranks' }].freeze

        private

        def command_action
          role_id = event.options['role'].to_i

          if ranks_repository.find_by_role(role_id:).nil?
            return transmitter.error_response(event:, text: t('commands.administrator.rank.remove.no_matching_rank'))
          end

          ranks_repository.delete(role_id:)
          transmitter.response(event:, text: t('commands.administrator.rank.remove.rank_successfully_removed'))
        end

        def ranks_repository
          @ranks_repository ||= Repositories::RanksRepository.new(server_service:)
        end
      end
    end
  end
end
