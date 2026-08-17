# frozen_string_literal: true

module Commands
  module Administrator
    module MaxLevel
      class MaxLevel < ParentCommand
        NAME = :max_level
        DESCRIPTION = 'Edit the maximum level'
        SUBCOMMANDS = [Set].freeze
      end
    end
  end
end
