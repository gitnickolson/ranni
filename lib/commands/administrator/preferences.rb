# frozen_string_literal: true

module Commands
  module Administrator
    class Preferences < Command
      NAME = :preferences
      DESCRIPTION = 'Retrieve the set preferences for the bot on this server'

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
          field.new(name: t('commands.administrator.preferences.language'),
                    value: server_service.locale, inlined: true),
          field.new(name: t('commands.administrator.preferences.timezone'),
                    value: server_service.timezone, inlined: true),
          field.new(name: t('commands.administrator.preferences.display_color'),
                    value: "`#{server_service.server_color}`", inlined: true),
          field.new,
          field.new,
          text_leveling_status_field,
          voice_leveling_status_field,
          max_level_field,
          level_up_message_channel_field,
          field.new,
          field.new,
          birthday_role_field,
          birthday_celebration_channel_field,
          field.new,
          field.new,
          welcome_message_channel_field
        ].compact
      end

      def max_level_field
        field.new(name: t('commands.administrator.preferences.max_level'),
                  value: server_service.max_level, inlined: true)
      end

      def text_leveling_status_field
        field.new(name: t('commands.administrator.preferences.text_leveling_status'),
                  value: if server_service.text_leveling_enabled?
                           t('commands.administrator.preferences.on')
                         else
                           t('commands.administrator.preferences.off')
                         end, inlined: true)
      end

      def voice_leveling_status_field
        field.new(name: t('commands.administrator.preferences.voice_leveling_status'),
                  value: if server_service.voice_leveling_enabled?
                           t('commands.administrator.preferences.on')
                         else
                           t('commands.administrator.preferences.off')
                         end, inlined: true)
      end

      def level_up_message_channel_field
        field.new(name: t('commands.administrator.preferences.level_up_messages_channel'),
                  value: server_service.level_up_congratulation_channel&.mention || '//', inlined: true)
      end

      def welcome_message_channel_field
        field.new(name: t('commands.administrator.preferences.welcome_messages_channel'),
                  value: server_service.welcome_message_channel&.mention || '//', inlined: true)
      end

      def birthday_celebration_channel_field
        field.new(name: t('commands.administrator.preferences.birthday_celebration_channel'),
                  value: server_service.birthday_celebration_channel&.mention || '//')
      end

      def birthday_role_field
        field.new(name: t('commands.administrator.preferences.birthday_role'),
                  value: server_service.birthday_role&.mention || '//', inlined: true)
      end
    end
  end
end
