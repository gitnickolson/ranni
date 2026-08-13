# frozen_string_literal: true

module Commands
  module Administrator
    module DefaultColor
      class DefaultColor < ParentCommand
        NAME = :default_color
        DESCRIPTION = 'Bearbeite die Standardfarbe von Anzeigen des Bots'
        SUBCOMMANDS = [Change].freeze
      end
    end
  end
end
