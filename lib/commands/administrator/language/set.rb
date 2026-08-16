# frozen_string_literal: true

module Commands
  module Administrator
    module Language
      class Set < Subcommand
        NAME = :set
        DESCRIPTION = 'Set the bot language'
        PARAMETERS = [{ type: :string, name: :language, required: true, description: 'Choose the new language',
                        choices: { de: 'de', en: 'en' } }].freeze

        private

        def command_action
          locale = event.options['language']

          preferences_repository.update_locale(locale:)
          transmitter.response(event:,
                               text: t('commands.administrator.language.set.language_successfully_set',
                                       { locale: }))
        end

        def preferences_repository
          @preferences_repository ||= Repositories::PreferencesRepository.new(server_id: server.id)
        end
      end
    end
  end
end
