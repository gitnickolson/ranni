# frozen_string_literal: true

module Commands
  module Administrator
    module ConditionalRoles
      class Add < Subcommand
        NAME = :add
        DESCRIPTION = 'Add a new conditional role'
        PARAMETERS = [{ type: :role, name: :role, required: true,
                        description: 'Choose the corresponding role' },
                      { type: :string, name: :condition, required: true,
                        description: 'Enter the condition that has to be met to get the role' }].freeze
        MAX_CONDITION_LENGTH = 100

        private

        def command_action
          role_id = event.options['role'].to_i
          condition = event.options['condition']

          result = validate_options(role_id, condition)
          return transmitter.error_response(event:, text: result.value) if result.failure?

          conditional_roles_repository.create(role_id:, condition:)
          transmitter.response(
            event:,
            text: t('commands.administrator.conditional_roles.add.conditional_role_successfully_created')
          )
        end

        def validate_options(role_id, condition)
          unless roles_repository.role_exists?(role_id:)
            return Utility::Result.failure(error: t('commands.administrator.conditional_roles.add.role_does_not_exist'))
          end

          validator = Validation::ConditionalRolesValidator.new(server_service:)
          validator.validate_creation(role_id:, condition:)
        end

        def conditional_roles_repository
          @conditional_roles_repository ||= Repositories::ConditionalRolesRepository.new(server_service:)
        end

        def roles_repository
          @roles_repository ||= Repositories::RolesRepository.new(server_service:)
        end
      end
    end
  end
end
