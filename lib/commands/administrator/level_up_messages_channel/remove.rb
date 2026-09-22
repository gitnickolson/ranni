# frozen_string_literal: true

module Commands
  module Administrator
    module LevelUpMessagesChannel
      class Remove < Subcommand
        NAME = :remove
        DESCRIPTION = 'Remove the current channel for level-up messages'

        private

        def command_action
          preferences_repository.set_level_up_congratulation_channel(channel_id: nil)
          transmitter.response(event:,
                               text: t(
                                 'commands.administrator.level_up_messages_channel.remove.channel_successfully_removed'
                               ))
        end

        def preferences_repository
          server_service.preferences_repository
        end
      end
    end
  end
end
