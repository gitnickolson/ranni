# frozen_string_literal: true

module Commands
  module Public
    module Birthday
      class Birthday
        NAME = :birthday
        DESCRIPTION = 'Options regarding your birthday'
        SUBCOMMANDS = [Set, Remove, List].freeze
      end
    end
  end
end
