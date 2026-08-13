# frozen_string_literal: true

module Commands
  module Administrator
    module Ranks
      class Rank < ParentCommand
        NAME = :rank
        DESCRIPTION = 'Bearbeite die Ränge des Servers'
        SUBCOMMANDS = [Add, Remove, List].freeze

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
