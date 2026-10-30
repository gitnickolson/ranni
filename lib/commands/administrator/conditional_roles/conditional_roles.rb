# frozen_string_literal: true

module Commands
  module Administrator
    module ConditionalRoles
      class ConditionalRoles < ParentCommand
        NAME = :conditional_roles
        DESCRIPTION = 'Change the conditional roles on this server'
        SUBCOMMANDS = [Add, Remove, Commands::Public::ConditionalRoles::List].freeze
      end
    end
  end
end
