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

          preferences_repository.set_ticket_creation_channel(channel_id:)
          transmitter.response(event:,
                               text: t('commands.administrator.ticket_creation_channel.set.channel_successfully_set',
                                       { channel: channel.mention }))
        end

        def preferences_repository
          server_service.preferences_repository
        end
      end
    end
  end
end
