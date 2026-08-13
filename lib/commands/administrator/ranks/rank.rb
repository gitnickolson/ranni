# frozen_string_literal: true

module Commands
  module Administrator
    module Ranks
      class Rank < ParentCommand
        NAME = :rank
        DESCRIPTION = 'Bearbeite die Level-basierten Ränge des Servers'
        SUBCOMMANDS = [Add, Remove, List].freeze
      end
    end
  end
end
