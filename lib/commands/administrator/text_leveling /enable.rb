# frozen_string_literal: true

module Commands
  module Administrator
    module TextLeveling
      class Enable < ParentCommand
        NAME = :enable
        DESCRIPTION = 'Schalte Text-Leveling aus'

        private

        def command_action
          preferences_repository.update_text_leveling_status(turned_on: false)
          transmitter.response(event:, text: 'Text-Leveling wurde erfolgreich ausgeschaltet.')
        end

        def preferences_repository
          @preferences_repository ||= Repositories::PreferencesRepository.new(server_service:)
        end
      end
    end
  end
end
