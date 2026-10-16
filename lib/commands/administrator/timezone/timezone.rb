# frozen_string_literal: true

module Commands
  module Administrator
    module Timezone
      class Timezone < ParentCommand
        NAME = :timezone
        DESCRIPTION = 'Change the bot timezone'
        SUBCOMMANDS = [Set].freeze
      end
    end
  end
end
