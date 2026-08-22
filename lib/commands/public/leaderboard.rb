# frozen_string_literal: true

module Commands
  module Public
    class Leaderboard < Command
      NAME = :leaderboard
      DESCRIPTION = 'Retreve the leveling leaderboard for this server'

      private

      def command_action
        embed_builder = create_embed_builder
        transmitter.embed_response(event:, embed_builder:)
      end

      def create_embed_builder
        embed_builder = builder.new(bot:, server_service:, pagination_key:, max_page_items: 10)

        embed_builder.update_fields(fields:)
        embed_builder.add_thumbnail(thumbnail_url: server.icon_url)
        embed_builder.add_title(text: t('commands.public.leaderboard.heading', { server_name: server.name }))
        embed_builder.change_footer(text: t('commands.public.leaderboard.personal_rank',
                                            { personal_rank: "##{personal_rank}" }),
                                    append_to_default: true)
      end

      def fields
        sorted_levels.map.with_index do |level, index|
          member = server_service.member_from(identifier: level.user_id)
          field.new(name: "#{index + 1}. #{server_service.display_name(user_id: member.id)}",
                    value: "#{t('commands.public.leaderboard.level')}: `#{level.numeric}`\n" \
                           "#{t('commands.public.leaderboard.xp')}: `#{humanize(level.experience_points)}`")
        end
      end

      def personal_rank
        index = sorted_levels.find_index do |level|
          level.user_id.to_i == event.user.id
        end

        return 0 if index.nil?

        index + 1
      end

      def sorted_levels
        levels_repository.all(active: true)
      end

      def humanize(number)
        Utility::NumberFormatter.humanize(number:, shorten: false)
      end

      def levels_repository
        @levels_repository ||= Repositories::LevelsRepository.new(server_service:)
      end
    end
  end
end
