# frozen_string_literal: true

module Commands
  module Administrator
    module Tickets
      class Enable < Subcommand
        NAME = :enable
        DESCRIPTION = 'Enable ticket creation'

        private

        def command_action
          preferences_repository.update_ticket_creation_status(turned_on: true)

          transmitter.response(event:,
                               text:
                               t('commands.administrator.tickets.enable.tickets_successfully_enabled'))
        end

        def preferences_repository
          @preferences_repository ||= Repositories::PreferencesRepository.new(server_id: server.id)
        end
      end
    end
  end
end
