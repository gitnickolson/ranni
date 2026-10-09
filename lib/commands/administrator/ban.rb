# frozen_string_literal: true

module Commands
  module Administrator
    class Ban < Command
      NAME = :ban
      DESCRIPTION = 'Ban a user'
      PARAMETERS = [{ type: :user, name: :user, required: true,
                      description: 'Choose a user' },
                    { type: :string, name: :reason, required: false,
                      description: 'Specify a reason' },
                    { type: :string, name: :cleanup, required: false,
                      choices: { '✅' => 'true', '❌' => 'false' },
                      description: 'Should messages from this user sent in the past 24h be deleted?' }].freeze
      ONE_DAY = 86_400

      private

      def command_action
        member = server_service.member_from(identifier: event.options['user'])

        return transmitter.error_response(event:, text: t('commands.administrator.ban.admin_ban')) if admin?(member)

        reason = event.options['reason']&.capitalize
        send_dm_with_reason(member, reason) if reason

        display_name = server_service.display_name(user_id: member.id, full: true)

        transmitter.response(event:,
                             text: t('commands.administrator.ban.success_response',
                                     { display_name: }))
        member.ban(message_seconds: clean_up_messages? ? ONE_DAY : 0, reason:)
      end

      def admin?(member)
        permission_checker.administrator?(user: member)
      end

      def send_dm_with_reason(member, reason)
        transmitter.send_message(channel: member.pm,
                                 text: t('commands.administrator.ban.ban_dm',
                                         { server_name: server.name, reason: }))
      end

      def clean_up_messages?
        event.options['cleanup'] == 'true' || event.options['cleanup'].nil?
      end
    end
  end
end
