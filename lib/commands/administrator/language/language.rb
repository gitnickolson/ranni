# frozen_string_literal: true

module Commands
  module Administrator
    module Language
      class Language < ParentCommand
        NAME = :language
        DESCRIPTION = 'Change the bot language'
        SUBCOMMANDS = [Set].freeze
      end
    end
  end
end
