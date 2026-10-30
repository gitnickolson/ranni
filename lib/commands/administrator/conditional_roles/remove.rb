# frozen_string_literal: true

module Commands
  module Administrator
    module ConditionalRoles
      class Remove < Subcommand
        NAME = :remove
        DESCRIPTION = 'Remove a conditional role'
        PARAMETERS = [{ type: :role, name: :role, required: true,
                        description: 'Choose the role that should be removed from the conditional roles' }].freeze

        private

        def command_action
          role_id = event.options['role'].to_i

          return no_matching_conditional_role_response if conditional_roles_repository.find_by_role(role_id:).nil?

          conditional_roles_repository.delete(role_id:)
          transmitter.response(
            event:,
            text: t('commands.administrator.conditional_roles.remove.conditional_role_successfully_removed')
          )
        end

        def no_matching_conditional_role_response
          transmitter.error_response(
            event:,
            text: t('commands.administrator.conditional_roles.remove.no_matching_conditional_role')
          )
        end

        def conditional_roles_repository
          @conditional_roles_repository ||= Repositories::ConditionalRolesRepository.new(server_service:)
        end
      end
    end
  end
end
