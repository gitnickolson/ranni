# frozen_string_literal: true

module Commands
  module Administrator
    module DefaultColor
      class DefaultColor < ParentCommand
        NAME = :default_color
        DESCRIPTION = 'Bearbeite die Standardfarbe von Anzeigen des Bots'
        SUBCOMMANDS = [Change].freeze

        def register
          bot.register_application_command(self.class::NAME, self.class::DESCRIPTION,
                                           server_id: server.id) do |command|
            register_subcommands(command)
          end
        end
      end
    end
  end
end
