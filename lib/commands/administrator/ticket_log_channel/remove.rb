# frozen_string_literal: true

module Commands
  module Administrator
    module TicketLogChannel
      class Remove < Subcommand
        NAME = :remove
        DESCRIPTION = 'Remove the current channel for ticket logging'

        private

        def command_action
          preferences_repository.remove_ticket_log_channel
          transmitter.response(event:,
                               text: t('commands.administrator.ticket_log_channel.remove.channel_successfully_removed'))
        end

        def preferences_repository
          @preferences_repository ||= Repositories::PreferencesRepository.new(server_id: server.id)
        end
      end
    end
  end
end
