# frozen_string_literal: true

module Commands
  module Administrator
    module TicketCreationChannel
      class Set < Subcommand
        NAME = :set
        DESCRIPTION = 'Set a channel for ticket creation'
        PARAMETERS = [{ type: :channel, name: :channel, required: true,
                        description: 'Choose the channel for ticket creation' }].freeze

        private

        def command_action
          channel_id = event.options['channel']
          channel = server_service.channel_from_id(channel_id:)

          unless preferences_repository.ticket_creation_message_id.nil? || server_service.ticket_creation_channel.nil?
            delete_old_message
          end

          preferences_repository.set_ticket_creation_channel(channel_id:)

          ticket_creation_message_manager.send_full_ticket_message

          transmitter.response(event:,
                               text: t('commands.administrator.ticket_creation_channel.set.channel_successfully_set',
                                       { channel: channel.mention }))
        end

        def delete_old_message
          ticket_creation_message_manager.delete_ticket_creation_message
        end

        def ticket_creation_message_manager
          @ticket_creation_message_manager ||= Utility::Tickets::TicketCreationMessageManager.new(server_service:)
        end

        def preferences_repository
          server_service.preferences_repository
        end
      end
    end
  end
end
