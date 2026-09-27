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

          send_ticket_creation_button_message(channel:)
          transmitter.response(event:,
                               text: t('commands.administrator.ticket_creation_channel.set.channel_successfully_set',
                                       { channel: channel.mention }))
        end

        def send_ticket_creation_button_message(channel:)
          ticket_button = create_ticket_creation_button
          message = transmitter.send_message(channel:,
                                             text: t('commands.administrator.ticket_creation_channel.set.intro_text'),
                                             buttons: [ticket_button])

          preferences_repository.set_ticket_creation_message(message_id: message.id)
        end

        def create_ticket_creation_button
          Utility::Messages::Buttons::Button.new(custom_id: "ticket_creation_button_#{Time.now.to_i}", label:
            t('commands.administrator.ticket_creation_channel.set.button_label'), style: 1) do |event|
            ticket_creator = Utility::Tickets::TicketCreator.new(server_service:, event:)
            ticket_creator.call
          end
        end

        def preferences_repository
          server_service.preferences_repository
        end
      end
    end
  end
end
