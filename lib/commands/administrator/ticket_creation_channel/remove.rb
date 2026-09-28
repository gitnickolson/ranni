# frozen_string_literal: true

module Commands
  module Administrator
    module TicketCreationChannel
      class Remove < Subcommand
        NAME = :remove
        DESCRIPTION = 'Remove the current channel for ticket creation'

        private

        def command_action
          previous_channel = server_service.ticket_creation_channel

          ticket_creation_message_manager = Utility::Tickets::TicketCreationMessageManager.new(server_service:)
          ticket_creation_message_manager.delete_ticket_creation_message

          preferences_repository.set_ticket_creation_channel(channel_id: nil)
          preferences_repository.set_ticket_creation_message(message_id: nil)
          transmitter.response(event:, text:
            t('commands.administrator.ticket_creation_channel.remove.channel_successfully_removed',
              { channel: previous_channel.mention }))
        end

        def preferences_repository
          server_service.preferences_repository
        end
      end
    end
  end
end
