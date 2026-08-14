# frozen_string_literal: true

module Commands
  module Administrator
    module LevelUpMessagesChannel
      class Remove < Subcommand
        NAME = :remove
        DESCRIPTION = 'Entferne den Kanal für Level-Up Nachrichten'

        private

        def command_action
          preferences_repository.remove_level_up_congratulation_channel
          transmitter.response(event:, text: 'Es erscheinen nun keine Level-Up Nachrichten mehr..')
        end

        def preferences_repository
          @preferences_repository ||= Repositories::PreferencesRepository.new(server_id: server.id)
        end
      end
    end
  end
end
