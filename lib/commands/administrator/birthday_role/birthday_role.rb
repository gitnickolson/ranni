# frozen_string_literal: true

module Commands
  module Administrator
    module BirthdayRole
      class BirthdayRole < ParentCommand
        NAME = :birthday_role
        DESCRIPTION = 'Options regarding the birthday role'
        SUBCOMMANDS = [Set, Remove].freeze
      end
    end
  end
end
