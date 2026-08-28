# frozen_string_literal: true

module Commands
  module Administrator
    module TicketLogChannel
      class TicketLogChannel
        NAME = :ticket_log_channel
        DESCRIPTION = 'Options regarding the ticket log channel'
        SUBCOMMANDS = [Set, Remove].freeze
      end
    end
  end
end
