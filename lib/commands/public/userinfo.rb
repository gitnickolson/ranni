# frozen_string_literal: true

module Commands
  module Public
    class Userinfo < Command
      NAME = :userinfo
      DESCRIPTION = 'Rufe Informationen zu dir oder einem anderen Nutzer ab.'

      def register
        bot.register_application_command(NAME, DESCRIPTION, server_id: server.id) do |command|
          command.user('user', 'Spezifiziere einen Nutzer.', required: false)
        end
      end

      private

      def command_action
        parameter_user_id = event.options['user']
        member = server_service.member_from(identifier: parameter_user_id || event.user.id)

        embed_builder = create_embed_builder(member)
        transmitter.embed_response(event:, embed_builder:)
      end

      def create_embed_builder(member)
        fields = fields(member)
        embed_builder = builder.new(bot:, pagination_key:, server_service:,
                                    max_page_items: calculate_max_page_items(fields))

        embed_builder.update_fields(fields:)
        embed_builder.add_thumbnail(thumbnail_url: member.avatar_url)
        embed_builder.add_title(text: username_with_nickname(member))
        embed_builder.change_color(color_code: member.color.to_i)
        embed_builder.change_footer(text: member.id, icon_url: server.icon_url, append_to_default: true)
      end

      def fields(member)
        [
          field.new(name: 'Generelles', value: general_info_string(member)),
          field.new,
          field.new(name: 'Account erstellt', value: "`#{parse_date(member.creation_time)}`", inlined: true),
          field.new(name: 'Beigetreten', value: "`#{parse_date(member.joined_at)}`", inlined: true),
          boosting_field(member),
          text_level_field(member)
        ].compact
      end

      def boosting_field(member)
        return unless member.boosting?

        field.new(name: 'Boostet seit', value: "`#{parse_date(member.boosting_since)}`", inlined: true)
      end

      def general_info_string(member)
        "Rang: #{member.highest_role.mention}\n" \
          "Status: #{member.status.to_s.capitalize}\n" \
          "#{"Boostet diesen Server \n" if member.boosting?}"
      end

      def text_level_field(member)
        return unless preferences_repository.text_leveling_enabled?

        field.new(name: '**Text-Level**', value: text_level_field_content(member))
      end

      def text_level_field_content(member)
        level = text_levels_repository.find_by_user_id(user_id: member.id)
        return if level.nil?

        numeric = level.numeric
        xp = level.experience_points

        "Level: #{numeric}\n" \
          "XP: `#{humanize(xp)}`/" \
          "`#{humanize(text_levels_repository.required_xp_for(level_numeric: numeric + 1))}`"
      end

      def username_with_nickname(member)
        server_service.display_name(user_id: member.id, full: true)
      end

      def calculate_max_page_items(fields)
        return fields.length unless preferences_repository.text_leveling_enabled?

        fields.length - 1
      end

      def humanize(number)
        Utility::NumberFormatter.humanize(number:, shorten: false)
      end

      def parse_date(date)
        Utility::TimeParser.parse_to_readable_date(date:)
      end

      def text_levels_repository
        @text_levels_repository ||= Repositories::TextLevelsRepository.new(server_service:)
      end

      def preferences_repository
        @preferences_repository ||= Repositories::PreferencesRepository.new(server_id: server.id)
      end
    end
  end
end
