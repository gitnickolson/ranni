# frozen_string_literal: true

module Commands
  module Administrator
    module CustomVoiceChannelCategory
      class Remove < Subcommand
        NAME = :remove
        DESCRIPTION = 'Remove the current category for custom voice channels'

        private

        def command_action
          preferences_repository.remove_custom_voice_channel_category
          transmitter.response(
            event:,
            text: t('commands.administrator.custom_voice_channel_category.remove.category_successfully_removed')
          )
        end

        def preferences_repository
          @preferences_repository ||= Repositories::PreferencesRepository.new(server_id: server.id)
        end
      end
    end
  end
end
