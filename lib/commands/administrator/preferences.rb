# frozen_string_literal: true

module Commands
  module Administrator
    class Preferences < Command
      NAME = :preferences
      DESCRIPTION = 'Rufe die Boteinstellungen für diesen Server ab'

      private

      def command_action
        embed_builder = create_embed_builder
        transmitter.embed_response(event:, embed_builder:)
      end

      def create_embed_builder
        embed_builder = builder.new(bot:, server_service:, pagination_key:, max_page_items: 20)

        embed_builder.update_fields(fields:)
        embed_builder.add_title(text: t('commands.administrator.preferences.embed_title',
                                        { bot_name: bot.name, server_name: server.name }))
      end

      def fields # rubocop:disable Metrics/MethodLength
        [
          field.new(name: t('commands.administrator.preferences.default_color'),
                    value: preferences_repository.server_color, inlined: true),
          field.new(name: t('commands.administrator.preferences.timezone'),
                    value: preferences_repository.timezone, inlined: true),
          field.new(name: t('commands.administrator.preferences.language'),
                    value: preferences_repository.locale, inlined: true),
          birthday_field,
          field.new,
          max_text_level_field,
          max_voice_level_field,
          text_leveling_status_field,
          level_up_message_channel_field,
          welcome_message_channel_field
        ].compact
      end

      def birthday_field
        return if birthday_role.nil?

        field.new(name: t('commands.administrator.preferences.birthday_role'),
                  value: birthday_role.mention, inlined: true)
      end

      def max_text_level_field
        field.new(name: t('commands.administrator.preferences.max_text_level'),
                  value: preferences_repository.max_text_level, inlined: true)
      end

      def max_voice_level_field
        field.new(name: t('commands.administrator.preferences.max_voice_level'),
                  value: preferences_repository.max_voice_level, inlined: true)
      end

      def text_leveling_status_field
        field.new(name: t('commands.administrator.preferences.text_leveling_status'),
                  value: if preferences_repository.text_leveling_enabled?
                           t('commands.administrator.preferences.on')
                         else
                           t('commands.administrator.preferences.off')
                         end)
      end

      def level_up_message_channel_field
        field.new(name: t('commands.administrator.preferences.level_up_messages_channel'),
                  value: level_up_congratulation_channel&.mention || '//')
      end

      def welcome_message_channel_field
        field.new(name: t('commands.administrator.preferences.welcome_messages_channel'),
                  value: welcome_message_channel&.mention || '//')
      end

      def level_up_congratulation_channel
        server_service.channel_from_id(channel_id: preferences_repository.level_up_congratulation_channel_id)
      end

      def welcome_message_channel
        server_service.channel_from_id(channel_id: preferences_repository.welcome_message_channel_id)
      end

      def birthday_role
        roles_repository.role_from_id(role_id: preferences_repository.birthday_role_id)
      end

      def preferences_repository
        @preferences_repository ||= Repositories::PreferencesRepository.new(server_id: server.id)
      end

      def roles_repository
        @roles_repository ||= Repositories::RolesRepository.new(server_service:)
      end
    end
  end
end
