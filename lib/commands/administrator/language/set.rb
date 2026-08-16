# frozen_string_literal: true

module Commands
  module Administrator
    module Language
      class Set < Subcommand
        NAME = :set
        DESCRIPTION = 'Stelle die Sprache ein'

        def self.register(discordrb_parent_command:)
          discordrb_parent_command.subcommand(NAME, DESCRIPTION) do |subcommand|
            subcommand.string('sprache', 'Die neue Sprache', choices: { De: 'De', En: 'En' }, required: true)
          end
        end

        private

        def command_action
          locale = event.options['sprache']

          preferences_repository.update_locale(locale:)
          transmitter.response(event:,
                               text: t('commands.administrator.language.language_successfully_set',
                                       { locale: }))
        end

        def preferences_repository
          @preferences_repository ||= Repositories::PreferencesRepository.new(server_id: server.id)
        end
      end
    end
  end
end
