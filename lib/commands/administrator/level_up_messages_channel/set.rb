# frozen_string_literal: true

module Commands
  module Administrator
    module LevelUpMessagesChannel
      class Set < Subcommand
        NAME = :set
        DESCRIPTION = 'Setze den Kanal für Level-Up-Nachrichten'

        def self.register_parameters(command)
          command.channel('kanal', 'Der neue Kanal für Level-Up-Nachrichten', required: true)
        end

        private

        def command_action
          channel_id = event.options['kanal'].to_i
          channel = server_service.channel_from_id(channel_id:)

          preferences_repository.add_level_up_congratulation_channel(channel_id:)
          transmitter.response(event:,
                               text: t('commands.administrator.level_up_messages_channel.channel_successfully_set',
                                       { channel: channel.mention }))
        end

        def preferences_repository
          @preferences_repository ||= Repositories::PreferencesRepository.new(server_id: server.id)
        end
      end
    end
  end
end
