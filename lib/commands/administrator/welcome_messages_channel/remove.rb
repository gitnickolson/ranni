# frozen_string_literal: true

module Commands
  module Administrator
    module WelcomeMessagesChannel
      class Remove < Subcommand
        NAME = :remove
        DESCRIPTION = 'Entferne den Kanal für Willkommensnachrichten'

        private

        def command_action
          preferences_repository.remove_welcome_message_channel
          transmitter.response(event:,
                               text: t('commands.administrator.welcome_messages_channel.channel_successfully_removed'))
        end

        def preferences_repository
          @preferences_repository ||= Repositories::PreferencesRepository.new(server_id: server.id)
        end
      end
    end
  end
end
