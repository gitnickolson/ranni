# frozen_string_literal: true

module Commands
  module Administrator
    module Rank
      class Add < Subcommand
        NAME = :add
        DESCRIPTION = 'Add a new rank'
        PARAMETERS = [{ type: :role, name: :role, required: true,
                        description: 'Choose the corresponding role' },
                      { type: :integer, name: :level, required: true,
                        description: 'Enter the required level' }].freeze

        private

        def command_action
          role_id = event.options['role'].to_i
          required_level = event.options['level'].to_i

          result = validate_options(role_id, required_level)
          return transmitter.error_response(event:, text: result.value) if result.failure?

          ranks_repository.create(role_id:, required_level:)
          transmitter.response(event:, text: t('commands.administrator.rank.add.rank_successfully_created'))
        end

        def validate_options(role_id, required_level)
          unless roles_repository.role_exists?(role_id:)
            return Utility::Result.failure(error: t('commands.administrator.rank.add.role_does_not_exist'))
          end

          rank_result = ranks_validator.validate_creation(role_id:, required_level:)
          return rank_result if rank_result.failure?

          level_validator.validate_level(level: required_level)
        end

        def ranks_validator
          @ranks_validator ||= Validation::RanksValidator.new(server_service:)
        end

        def level_validator
          @level_validator ||= Validation::LevelValidator.new(server_service:)
        end

        def ranks_repository
          @ranks_repository ||= Repositories::RanksRepository.new(server_service:)
        end

        def roles_repository
          @roles_repository ||= Repositories::RolesRepository.new(server_service:)
        end
      end
    end
  end
end
