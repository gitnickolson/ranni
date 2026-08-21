# frozen_string_literal: true

module Commands
  module Administrator
    class Kick < Command
      NAME = :kick
      DESCRIPTION = 'Kick a user'
      PARAMETERS = [{ type: :user, name: :user, required: true,
                      description: 'Choose a user' },
                    { type: :string, name: :reason, required: false,
                      description: 'Specify a reason' }].freeze

      private

      def command_action
        member = server_service.member_from(identifier: event.options['user'])

        return transmitter.error_response(event:, text: t('commands.administrator.kick.admin_kick')) if admin?(member)

        reason = event.options['reason']&.capitalize
        send_dm_with_reason(member, reason) if reason

        display_name = server_service.display_name(user_id: member.id, full: true)
        member.kick(reason)

        transmitter.response(event:,
                             text: t('commands.administrator.kick.success_response',
                                     { display_name: }))
      end

      def admin?(member)
        permission_checker.administrator?(user: member)
      end

      def send_dm_with_reason(member, reason)
        transmitter.send_message(channel: member.pm,
                                 text: t('commands.administrator.kick.kick_dm',
                                         { server_name: server.name, reason: }))
      end
    end
  end
end
