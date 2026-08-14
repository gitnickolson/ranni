# frozen_string_literal: true

module Commands
  module Administrator
    module TextLeveling
      class TextLeveling < ParentCommand
        NAME = :text_leveling
        DESCRIPTION = 'Schalte Text-Leveling ein oder aus'
        SUBCOMMANDS = [Enable, Disable].freeze
      end
    end
  end
end
