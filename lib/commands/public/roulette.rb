# frozen_string_literal: true

module Commands
  module Public
    class Roulette < Command
      NAME = :roulette
      DESCRIPTION = 'Put yourself in timeout with a chance of 1/6'
      CHANCE_OF_TIMEOUT = 1.0 / 6.0
      TIMEOUT_DURATION = 60

      private

      def command_action
        user = event.user
        channel = event.channel

        transmitter.response(event:, text: t('commands.public.roulette.roulette_start', { display_name: }))

        channel.start_typing
        sleep(3)

        return transmitter.send_message(channel:, text: failure_text) if rand >= CHANCE_OF_TIMEOUT
        return transmitter.send_message(channel:, text: admin_abuse_text) if admin?(user)

        transmitter.send_message(channel:, text: t('commands.public.roulette.bad_luck', { display_name: }))
        user.timeout = Time.now + TIMEOUT_DURATION
      end

      def failure_text
        t('commands.public.roulette.good_luck', { display_name: })
      end

      def admin_abuse_text
        t('commands.public.roulette.admin_abuse', { display_name: })
      end

      def admin?(user)
        permission_checker.administrator?(user:)
      end

      def display_name
        server_service.display_name(user_id: event.user.id)
      end
    end
  end
end
