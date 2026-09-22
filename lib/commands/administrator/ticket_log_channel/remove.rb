# frozen_string_literal: true

module Commands
  module Administrator
    module TicketLogChannel
      class Remove < Subcommand
        NAME = :remove
        DESCRIPTION = 'Remove the current channel for ticket logging'

        private

        def command_action
          preferences_repository.set_ticket_log_channel(channel_id: nil)
          transmitter.response(event:,
                               text: t('commands.administrator.ticket_log_channel.remove.channel_successfully_removed'))
        end

        def preferences_repository
          server_service.preferences_repository
        end
      end
    end
  end
end
