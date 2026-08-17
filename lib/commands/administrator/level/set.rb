# frozen_string_literal: true

module Commands
  module Administrator
    module Level
      class Set < Subcommand
        NAME = :set
        DESCRIPTION = 'Set the level of a user'
        PARAMETERS = [{ type: :user, name: :user, required: true, description: 'Choose the affected user' },
                      { type: :integer, name: :level, required: true, description: 'Enter the new level' }].freeze

        private

        def command_action
          user_id = event.options['user']
          level_numeric = event.options['level']

          result = level_validator.validate_level(level: level_numeric)

          return transmitter.error_response(event:, text: result.value) if result.failure?

          levels_repository.update_numeric(user_id:, numeric: level_numeric)

          display_name = server_service.display_name(user_id:, full: true)
          transmitter.response(event:, text: t('commands.administrator.level.set.level_successfully_set',
                                               { display_name:, level: level_numeric }))
        end

        def level_validator
          @level_validator ||= Validation::LevelValidator.new(server_service:)
        end

        def levels_repository
          @levels_repository ||= Repositories::LevelsRepository.new(server_service:)
        end
      end
    end
  end
end
