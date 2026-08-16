# frozen_string_literal: true

module Commands
  module Administrator
    module TextLeveling
      class Enable < Subcommand
        NAME = :enable
        DESCRIPTION = 'Schalte Text-Leveling ein'

        private

        def command_action
          preferences_repository.update_text_leveling_status(turned_on: true)
          transmitter.response(event:,
                               text: t('commands.administrator.text_leveling.text_leveling_successfully_enabled'))
        end

        def preferences_repository
          @preferences_repository ||= Repositories::PreferencesRepository.new(server_id: server_service.server.id)
        end
      end
    end
  end
end
