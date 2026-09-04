# frozen_string_literal: true

module Commands
  module Public
    class Suggestion < Command
      NAME = :suggestion
      DESCRIPTION = 'Send an anonymous suggestion to the suggestion channel'
      PARAMETERS = [{ type: :string, name: :title, required: true,
                      description: 'Enter a title for your suggestion' },
                    { type: :string, name: :content, required: true,
                      description: 'Enter the content of your suggestion' }].freeze

      private

      def command_action
        suggestion_channel = server_service.suggestion_channel

        if suggestion_channel.nil?
          return transmitter.error_response(event:, text: t('commands.public.suggestion.suggestions_disabled'))
        end

        embed_builder = create_embed_builder
        transmitter.send_embed_message(channel: suggestion_channel, embed_builder: embed_builder)

        transmitter.response(event:, text: t('commands.public.suggestion.suggestion_created',
                                             { channel: suggestion_channel.mention }),
                             ephemeral: true, delete: true)
      end

      def create_embed_builder
        embed_builder = builder.new(bot:, server_service:, pagination_key:)

        embed_builder.add_title(text: event.options['title'])
        embed_builder.add_description(text: event.options['content'])
        embed_builder.change_footer(text: parsed_date)
      end

      def parsed_date
        Utility::TimeParser.parse_to_readable_date(date: server_service.now.to_date)
      end
    end
  end
end
