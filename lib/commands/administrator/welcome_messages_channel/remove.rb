# frozen_string_literal: true

module Commands
  module Administrator
    module WelcomeMessagesChannel
      class Remove < Subcommand
        NAME = :remove
        DESCRIPTION = 'Remove the welcome messages channel'

        private

        def command_action
          preferences_repository.remove_welcome_message_channel
          transmitter.response(event:,
                               text: t(
                                 'commands.administrator.welcome_messages_channel.remove.channel_successfully_removed'
                               ))
        end

        def preferences_repository
          @preferences_repository ||= Repositories::PreferencesRepository.new(server_id: server.id)
        end
      end
    end
  end
end
