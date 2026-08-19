# frozen_string_literal: true

module Commands
  module Administrator
    module BirthdayRole
      class Set < Subcommand
        NAME = :set
        DESCRIPTION = 'Set the birthday role'
        PARAMETERS = [{ type: :role, name: :role, required: true,
                        description: 'Choose the role that should be used as birthday role' }].freeze

        private

        def command_action
          role_id = event.options['role'].to_i

          if server_service.role_from_id(role_id:).nil?
            return transmitter.error_response(event:,
                                              text: t('commands.administrator.birthday_role.set.role_does_not_exist'))
          end

          preferences_repository.set_birthday_role(role_id:)
          transmitter.response(
            event:,
            text: t('commands.administrator.birthday_role.set.role_successfully_set', { role: role.mention })
          )
        end

        def preferences_repository
          @preferences_repository ||= Repositories::PreferencesRepository.new(server_id: server.id)
        end
      end
    end
  end
end
