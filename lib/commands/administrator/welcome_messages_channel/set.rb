# frozen_string_literal: true

module Commands
  module Administrator
    module WelcomeMessagesChannel
      class Set < Subcommand
        NAME = :set
        DESCRIPTION = 'Setze den Kanal für Willkommensnachrichten'

        def self.register(discordrb_parent_command:)
          discordrb_parent_command.subcommand(NAME, DESCRIPTION) do |subcommand|
            subcommand.channel('kanal', 'Der neue Kanal für Willkommensnachrichten.', required: true)
          end
        end

        private

        def command_action
          channel_id = event.options['kanal'].to_i
          channel = server_service.channel_from_id(channel_id:)

          preferences_repository.add_welcome_message_channel(channel_id:)
          transmitter.response(event:,
                               text: t(
                                 'commands.administrator.welcome_messages_channel.channel_successfully_set',
                                 { channel: channel.mention }
                               ))
        end

        def preferences_repository
          @preferences_repository ||= Repositories::PreferencesRepository.new(server_id: server.id)
        end
      end
    end
  end
end
