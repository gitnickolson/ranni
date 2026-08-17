# frozen_string_literal: true

module Commands
  module Administrator
    module Level
      class Level < ParentCommand
        NAME = :level
        DESCRIPTION = 'Edit the level of a user'
        SUBCOMMANDS = [Set].freeze
      end
    end
  end
end
