# frozen_string_literal: true

module Commands
  module Administrator
    module Ranks
      class Add < Subcommand
        NAME = :add
        DESCRIPTION = 'Füge einen neuen Rang zu den Levelrängen hinzu'

        def register(discordrb_parent_command:)
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

          Repositories::RanksRepository.create(role_id:, required_level:)
          transmitter.response(event:, text: 'Der Rang wurde erfolgreich erstellt.')
        end

        def validate_options(role_id, required_level)
          unless server_accessor.role_exists?(role_id:)
            return Utility::Result.failure(error: 'Diese Rolle existiert nicht.')
          end

          rank_result = Validation::RanksValidator.validate_creation(role_id:, required_level:)
          return rank_result if rank_result.failure?

          Validation::LevelValidator.validate(level: required_level)
        end

        def server_accessor
          @server_accessor ||= Utility::ServerAccessor.new(bot:, server_id:)
        end
      end
    end
  end
end
