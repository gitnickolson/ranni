# frozen_string_literal: true

module Commands
  module Administrator
    module DisplayColor
      class DisplayColor < ParentCommand
        NAME = :display_color
        DESCRIPTION = 'Change the display color of the bot'
        SUBCOMMANDS = [Set, Reset].freeze
      end
    end
  end
end
