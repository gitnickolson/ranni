# frozen_string_literal: true

module Commands
  module Administrator
    module Ranks
      class Remove < Subcommand
        NAME = :remove
        DESCRIPTION = 'Entferne einen Rang aus den Levelrängen'

        def register(discordrb_parent_command:)
          discordrb_parent_command.subcommand(NAME, DESCRIPTION) do |subcommand|
            subcommand.role('rolle', 'Gib die Rolle an, die aus den Rängen entfernt werden soll', required: true)
          end
        end

        private

        def command_action
          role_id = event.options['rolle']

          if Repositories::RanksRepository.find_by_role(role_id:).nil?
            return transmitter.error_response(event:, text: 'Für diese Rolle gibt es keinen zugehörigen Rang.')
          end

          Repositories::RanksRepository.delete(role_id:)
          transmitter.response(event:, text: 'Rang erfolgreich entfernt.')
        end
      end
    end
  end
end
