# frozen_string_literal: true

module Commands
  module Administrator
    module Language
      class Set < Subcommand
        NAME = :set
        DESCRIPTION = 'Stelle die Sprache ein'
        PARAMETERS = [{ type: :string, name: :language, required: true, description: 'Die neue Sprache',
                        choice: { De: 'De', En: 'En' } }].freeze

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
