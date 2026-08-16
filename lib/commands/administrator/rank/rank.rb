# frozen_string_literal: true

module Commands
  module Administrator
    module Rank
      class Rank < ParentCommand
        NAME = :rank
        DESCRIPTION = 'Change the level based ranks of the server'
        SUBCOMMANDS = [Add, Remove, List].freeze
      end
    end
  end
end
