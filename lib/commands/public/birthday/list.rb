# frozen_string_literal: true

module Commands
  module Public
    module Birthday
      class List < Subcommand
        NAME = :list
        DESCRIPTION = 'Retrieve a list of birthdays for this server'
        MAX_PAGE_ITEMS = 18

        private

        def command_action
          embed_builder = builder.new(bot:, server_service:, pagination_key:, max_page_items: MAX_PAGE_ITEMS)
          embed_builder.update_fields(fields:)
          embed_builder.add_title(text: t('commands.public.birthday.list.heading', { server_name: server.name }))

          transmitter.embed_response(event:, embed_builder:)
        end

        def fields
          birthdays_repository.all(on_server: true).map do |birthday|
            field.new(name: server_service.display_name(user_id: birthday.user_id, full: true),
                      value: "`#{formatted_date(birthday.date)}`",
                      inlined: true)
          end
        end

        def formatted_date(date)
          Utility::TimeParser.parse_to_readable_date(date:)
        end

        def birthdays_repository
          @birthdays_repository ||= Repositories::BirthdaysRepository.new(server_service:)
        end
      end
    end
  end
end
