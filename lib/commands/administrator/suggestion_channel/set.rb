# frozen_string_literal: true

module Commands
  module Administrator
    module SuggestionChannel
      class Set < Subcommand
        NAME = :set
        DESCRIPTION = 'Set a channel for suggestions'
        PARAMETERS = [{ type: :channel, name: :channel, required: true,
                        description: 'Choose the channel for suggestions' }].freeze

        private

        def command_action
          channel_id = event.options['channel']
          channel = server_service.channel_from_id(channel_id:)

          preferences_repository.add_suggestion_channel(channel_id:)
          transmitter.response(event:,
                               text: t('commands.administrator.suggestion_channel.set.channel_successfully_set',
                                       { channel: channel.mention }))
        end

        def preferences_repository
          server_service.preferences_repository
        end
      end
    end
  end
end
