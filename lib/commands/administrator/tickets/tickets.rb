# frozen_string_literal: true

module Commands
  module Administrator
    module Tickets
      class Tickets < ParentCommand
        NAME = :tickets
        DESCRIPTION = 'Enable or disable ticket creation'
        SUBCOMMANDS = [Enable, Disable].freeze
      end
    end
  end
end
