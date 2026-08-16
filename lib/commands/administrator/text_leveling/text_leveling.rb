# frozen_string_literal: true

module Commands
  module Administrator
    module TextLeveling
      class TextLeveling < ParentCommand
        NAME = :text_leveling
        DESCRIPTION = 'Enable or disable text leveling'
        SUBCOMMANDS = [Enable, Disable].freeze
      end
    end
  end
end
