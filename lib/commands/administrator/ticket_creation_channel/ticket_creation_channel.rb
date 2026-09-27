# frozen_string_literal: true

module Commands
  module Administrator
    module TicketCreationChannel
      class TicketCreationChannel < ParentCommand
        NAME = :ticket_creation_channel
        DESCRIPTION = 'Options regarding the ticket creation channel'
        SUBCOMMANDS = [Set, Remove].freeze
      end
    end
  end
end
