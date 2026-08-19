# frozen_string_literal: true

module Commands
  module Public
    module Birthday
      class Birthday < ParentCommand
        NAME = :birthday
        DESCRIPTION = 'Options regarding your birthday'
        SUBCOMMANDS = [Set, Remove, List].freeze
      end
    end
  end
end
