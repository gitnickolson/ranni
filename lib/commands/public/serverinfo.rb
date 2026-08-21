# frozen_string_literal: true

module Commands
  module Public
    class Serverinfo < Command
      NAME = :serverinfo
      DESCRIPTION = 'Retrieve information regarding the server'

      private

      def command_action
        embed_builder = create_embed_builder
        transmitter.embed_response(event:, embed_builder:)
      end

      def create_embed_builder
        embed_builder = builder.new(bot:, server_service:, pagination_key:)

        embed_builder.update_fields(fields:)
        embed_builder.add_thumbnail(thumbnail_url: server.icon_url)
        embed_builder.add_title(text: server.name)
        embed_builder.change_footer(text: "#{t('commands.public.serverinfo.server_id')}: #{server.id}")
      end

      def fields
        [
          field.new(name: t('commands.public.serverinfo.owner'),
                    value: server_service.display_name(user_id: server.owner.id, full: true)),
          field.new(name: t('commands.public.serverinfo.general_info'), value: general_info_string),

          field.new(name: t('commands.public.serverinfo.server_created'), value: "`#{parsed_creation_time}`",
                    inlined: true),
          field.new(name: t('commands.public.serverinfo.boost_status'), value: boost_status_string,
                    inlined: true)
        ]
      end

      def general_info_string
        "#{t('commands.public.serverinfo.members')}: #{server.member_count} (#{server.non_bot_members.count})\n" \
          "#{t('commands.public.serverinfo.bots')}: #{server.member_count - server.non_bot_members.count}\n" \
          "#{t('commands.public.serverinfo.channels')}: #{server.channels.count}\n" \
          "#{t('commands.public.serverinfo.roles')}: #{server.roles.count}"
      end

      def boost_status_string
        "`#{t('commands.public.serverinfo.level')} #{server.boost_level} | " \
          "#{server.booster_count} #{active_boosts_string}`"
      end

      def active_boosts_string
        return t('commands.public.serverinfo.active_boost') if server.booster_count == 1

        t('commands.public.serverinfo.active_boosts')
      end

      def parsed_creation_time
        @parsed_creation_time ||= Utility::TimeParser.parse_to_readable_date(date: server.creation_time)
      end
    end
  end
end
