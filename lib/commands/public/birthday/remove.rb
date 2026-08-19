# frozen_string_literal: true

module Commands
  module Public
    module Birthdays
      class Remove < Commands::Subcommand
        NAME = :remove
        DESCRIPTION = 'Remove your birthday'

        private

        def command_action
          birthdays_repository.delete(user_id: event.user.id)
          transmitter.response(event:, text: t('commands.public.birthdays.remove.birthday_successfully_removed'))
        end

        def birthdays_repository
          @birthdays_repository ||= Repositories::BirthdaysRepository.new(server_service:)
        end
      end
    end
  end
end
