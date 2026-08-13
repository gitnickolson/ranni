# frozen_string_literal: true

module Commands
  module Administrator
    module MaxTextLevel
      class MaxTextLevel < ParentCommand
        NAME = :max_text_level
        DESCRIPTION = 'Bearbeite das maximale Text-Level'
        SUBCOMMANDS = [Set].freeze
      end
    end
  end
end
