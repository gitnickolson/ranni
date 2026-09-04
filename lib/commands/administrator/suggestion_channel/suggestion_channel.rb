# frozen_string_literal: true

module Commands
  module Administrator
    module SuggestionChannel
      class SuggestionChannel < ParentCommand
        NAME = :suggestion_channel
        DESCRIPTION = 'Options regarding the suggestions channel'
        SUBCOMMANDS = [Set, Remove].freeze
      end
    end
  end
end
