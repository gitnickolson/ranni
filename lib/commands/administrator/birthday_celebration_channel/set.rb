# frozen_string_literal: true

module Commands
  module Administrator
    module BirthdayCelebrationChannel
      class Set < Subcommand
        NAME = :set
        DESCRIPTION = 'Set the birthday celebration channel'
        PARAMETERS = [{ type: :channel, name: :channel, required: true,
                        description: 'Choose the channel for birthday celebration messages' }].freeze

        private

        def command_action
          channel_id = event.options['channel'].to_i
          channel = server_service.channel_from_id(channel_id:)

          preferences_repository.set_birthday_celebration_channel_id(channel_id:)
          transmitter.response(event:,
                               text: t(
                                 'commands.administrator.birthday_celebration_channel.set.channel_successfully_set',
                                 { channel: channel.mention }
                               ))
        end

        def preferences_repository
          @preferences_repository ||= Repositories::PreferencesRepository.new(server_id: server.id)
        end
      end
    end
  end
end
