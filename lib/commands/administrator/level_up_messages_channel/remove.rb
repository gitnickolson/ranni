# frozen_string_literal: true

module Commands
  module Administrator
    module LevelUpMessagesChannel
      class Remove < Subcommand
        NAME = :remove
        DESCRIPTION = 'Remove the current channel for level-up messages'

        private

        def command_action
          preferences_repository.remove_level_up_congratulation_channel
          transmitter.response(event:,
                               text: t(
                                 'commands.administrator.level_up_messages_channel.remove.channel_successfully_removed'
                               ))
        end

        def preferences_repository
          @preferences_repository ||= Repositories::PreferencesRepository.new(server_id: server.id)
        end
      end
    end
  end
end
