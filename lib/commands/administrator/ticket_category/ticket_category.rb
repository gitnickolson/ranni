# frozen_string_literal: true

module Commands
  module Administrator
    module TicketCategory
      class TicketCategory < ParentCommand
        NAME = :ticket_category
        DESCRIPTION = 'Options regarding the category that ticket channels will appear in'
        SUBCOMMANDS = [Set, Remove].freeze
      end
    end
  end
end
