# frozen_string_literal: true

module Commands
  module Administrator
    class Timeout < Command
      NAME = :timeout
      DESCRIPTION = 'Timeout a user'
      PARAMETERS = [{ type: :user, name: :user, required: true,
                      description: 'Choose a user' },
                    { type: :integer, name: :duration, required: true,
                      description: 'Specify the duration in minutes' }].freeze

      private

      def command_action
        member = server_service.member_from(identifier: event.options['user'])

        if admin?(member)
          return transmitter.error_response(event:, text: t('commands.administrator.timeout.admin_timeout'))
        end

        display_name = server_service.display_name(user_id: member.id, full: true)
        minutes = event.options['duration'].to_i

        transmitter.response(event:,
                             text: t('commands.administrator.timeout.success_response',
                                     { display_name:, minutes: }))

        member.timeout = Time.now + (minutes * 60)
      end

      def admin?(member)
        permission_checker.administrator?(user: member)
      end
    end
  end
end
