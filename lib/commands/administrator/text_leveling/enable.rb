# frozen_string_literal: true

module Commands
  module Administrator
    module TextLeveling
      class Enable < Subcommand
        NAME = :enable
        DESCRIPTION = 'Enable text leveling'

        private

        def command_action
          preferences_repository.update_text_leveling_status(turned_on: true)
          transmitter.response(event:,
                               text:
                               t('commands.administrator.text_leveling.enable.text_leveling_successfully_enabled'))
        end

        def preferences_repository
          @preferences_repository ||= Repositories::PreferencesRepository.new(server_id: server.id)
        end
      end
    end
  end
end
