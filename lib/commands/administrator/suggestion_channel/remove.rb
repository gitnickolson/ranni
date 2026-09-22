# frozen_string_literal: true

module Commands
  module Administrator
    module SuggestionChannel
      class Remove < Subcommand
        NAME = :remove
        DESCRIPTION = 'Remove the current channel for suggestions'

        private

        def command_action
          preferences_repository.set_suggestion_channel(channel_id: nil)
          transmitter.response(event:,
                               text: t(
                                 'commands.administrator.suggestion_channel.remove.channel_successfully_removed'
                               ))
        end

        def preferences_repository
          server_service.preferences_repository
        end
      end
    end
  end
end
