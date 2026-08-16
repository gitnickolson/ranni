# frozen_string_literal: true

module Commands
  module Administrator
    module Language
      class Language < ParentCommand
        NAME = :language
        DESCRIPTION = 'Passe die Sprache des Bots an'
        SUBCOMMANDS = [Set].freeze
      end
    end
  end
end
