# frozen_string_literal: true

module Commands
  module Administrator
    module Tickets
      class Disable < Subcommand
        NAME = :disable
        DESCRIPTION = 'Disable ticket creation'

        private

        def command_action
          preferences_repository.update_ticket_creation_status(turned_on: false)
          transmitter.response(event:,
                               text:
                               t('commands.administrator.tickets.disable.tickets_successfully_disabled'))
        end

        def preferences_repository
          server_service.preferences_repository
        end
      end
    end
  end
end
