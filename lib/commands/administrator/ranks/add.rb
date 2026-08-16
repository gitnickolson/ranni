# frozen_string_literal: true

module Commands
  module Administrator
    module Ranks
      class Add < Subcommand
        NAME = :add
        DESCRIPTION = 'Füge einen neuen Rang zu den Levelrängen hinzu'

        def self.register(discordrb_parent_command:)
          discordrb_parent_command.subcommand(NAME, DESCRIPTION) do |subcommand|
            subcommand.role('rolle', 'Gib die zugehörige Rolle für den Rang an', required: true)
            subcommand.integer('level', 'Gib das benötigte level an', required: true)
          end
        end

        private

        def command_action
          role_id = event.options['rolle'].to_i
          required_level = event.options['level'].to_i

          result = validate_options(role_id, required_level)
          return transmitter.error_response(event:, text: result.value) if result.failure?

          ranks_repository.create(role_id:, required_level:)
          transmitter.response(event:, text: t('commands.administrator.rank.rank_successfully_created'))
        end

        def validate_options(role_id, required_level)
          unless roles_repository.role_exists?(role_id:)
            return Utility::Result.failure(error: t('commands.administrator.rank.role_does_not_exist'))
          end

          rank_result = ranks_validator.validate_creation(role_id:, required_level:)
          return rank_result if rank_result.failure?

          level_validator.validate_text_level(level: required_level)
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
