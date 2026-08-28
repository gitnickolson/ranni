# frozen_string_literal: true

module Commands
  module Administrator
    module TicketLogChannel
      class Set < Subcommand
        NAME = :set
        DESCRIPTION = 'Set a channel for ticket logging'
        PARAMETERS = [{ type: :channel, name: :channel, required: true,
                        description: 'Choose the channel for ticket logging' }].freeze

        private

        def command_action
          channel_id = event.options['channel']
          channel = server_service.channel_from_id(channel_id:)

          preferences_repository.add_ticket_log_channel(channel_id:)
          transmitter.response(event:,
                               text: t('commands.administrator.ticket_log_channel.set.channel_successfully_set',
                                       { channel: channel.mention }))
        end

        def preferences_repository
          @preferences_repository ||= Repositories::PreferencesRepository.new(server_id: server.id)
        end
      end
    end
  end
end
