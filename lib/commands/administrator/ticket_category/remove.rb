# frozen_string_literal: true

module Commands
  module Administrator
    module TicketCategory
      class Remove < Subcommand
        NAME = :remove
        DESCRIPTION = 'Remove the current category for ticket channels'

        private

        def command_action
          preferences_repository.remove_ticket_category
          transmitter.response(event:,
                               text: t('commands.administrator.ticket_category.remove.category_successfully_removed'))
        end

        def preferences_repository
          server_service.preferences_repository
        end
      end
    end
  end
end
