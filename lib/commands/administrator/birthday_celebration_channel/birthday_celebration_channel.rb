# frozen_string_literal: true

module Commands
  module Administrator
    module BirthdayCelebrationChannel
      class BirthdayCelebrationChannel < ParentCommand
        NAME = :birthday_celebration_channel
        DESCRIPTION = 'Options regarding the birthday celebration channel'
        SUBCOMMANDS = [Set, Remove].freeze
      end
    end
  end
end
