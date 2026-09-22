# frozen_string_literal: true

module Commands
  module Administrator
    module BirthdayCelebrationChannel
      class Remove < Subcommand
        NAME = :remove
        DESCRIPTION = 'Remove the birthday celebration channel'

        private

        def command_action
          preferences_repository.set_birthday_celebration_channel_id(channel_id: nil)
          transmitter.response(
            event:,
            text: t('commands.administrator.birthday_celebration_channel.remove.channel_successfully_removed')
          )
        end

        def preferences_repository
          server_service.preferences_repository
        end
      end
    end
  end
end
