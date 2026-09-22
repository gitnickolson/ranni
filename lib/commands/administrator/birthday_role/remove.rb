# frozen_string_literal: true

module Commands
  module Administrator
    module BirthdayRole
      class Remove < Subcommand
        NAME = :remove
        DESCRIPTION = 'Remove the birthday role'

        private

        def command_action
          preferences_repository.set_birthday_role(role_id: nil)
          transmitter.response(
            event:,
            text: t('commands.administrator.birthday_role.remove.role_successfully_removed')
          )
        end

        def preferences_repository
          server_service.preferences_repository
        end
      end
    end
  end
end
