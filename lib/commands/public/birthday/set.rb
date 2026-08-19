# frozen_string_literal: true

module Commands
  module Public
    module Birthday
      class Set < Subcommand
        NAME = :set
        DESCRIPTION = 'Set your birthday date'
        PARAMETERS = [{ type: :integer, name: :day, required: true, description: 'Enter the day of the month' },
                      { type: :integer, name: :month, required: true,
                        description: 'Enter the month of your birthday' },
                      { type: :integer, name: :year, required: true,
                        description: 'Enter the year of your birthday' }].freeze

        private

        def command_action
          date = Date.parse("#{event.options['year']}-#{event.options['month']}-#{event.options['day']}")

          birthdays_repository.update_or_create(user_id: event.user.id, date:)
          transmitter.response(event:, text: t('commands.public.birthday.set.birthday_successfully_set'))
        rescue ArgumentError
          transmitter.error_response(event:, text: t('commands.public.birthday.set.enter_a_valid_date'))
        end

        def birthdays_repository
          @birthdays_repository ||= Repositories::BirthdaysRepository.new(server_service:)
        end
      end
    end
  end
end
