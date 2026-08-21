# frozen_string_literal: true

require 'time'

module Commands
  module Public
    class Botinfo < Commands::Command
      NAME = :botinfo
      DESCRIPTION = 'Retrieve information regarding the bot'
      @start_time = Time.now

      class << self
        attr_reader :start_time
      end

      private

      def command_action
        embed_builder = create_embed_builder
        transmitter.embed_response(event:, embed_builder:)
      end

      def create_embed_builder
        embed_builder = builder.new(bot:, server_service:, pagination_key:)

        embed_builder.update_fields(fields:)
        embed_builder.add_thumbnail(thumbnail_url: server_service.member_from(identifier: server.bot.id).avatar_url)
        embed_builder.add_title(text: bot.name)
        embed_builder.change_footer(text: "Bot ID: #{server.bot.id}", icon_url: server.icon_url)
      end

      def fields
        [
          field.new(name: t('commands.public.botinfo.uptime'), value: time_since_boot, inlined: true),
          field.new(name: t('commands.public.botinfo.programming_language'), value: 'Ruby'),
          field.new(name: t('commands.public.botinfo.contributors'), value: '`nicknickolson`', inlined: true),
          field.new(name: t('commands.public.botinfo.bot_created'), value: "`#{created_at}`", inlined: true)

        ]
      end

      def time_since_boot
        Utility::TimeParser.parse_to_readable_time(time: Time.at((Time.now - self.class.start_time) - 1))
      end

      def created_at
        Utility::TimeParser.parse_to_readable_date(date: server.bot.creation_time)
      end
    end
  end
end
