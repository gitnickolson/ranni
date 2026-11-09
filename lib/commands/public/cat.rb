# frozen_string_literal: true

require 'cgi'

module Commands
  module Public
    class Cat < Command
      NAME = :cat
      DESCRIPTION = 'Retrieve a random cat'
      PARAMETERS = [{ type: :string, name: :text, description: 'Provide a text for the cat to say',
                      required: false }].freeze
      MAX_TEXT_LENGTH = 20
      MAX_WORDS = 1
      CACHE_INVALIDATION_VALUE = 100_000_0
      URL = 'https://cataas.com/cat'

      private

      def command_action
        text = event.options['text']

        return too_many_words_response if text && text.split.length > MAX_WORDS
        return text_too_long_response if text && text.length > MAX_TEXT_LENGTH

        event.defer(ephemeral: false)
        cat_id = Clients::CataasClient.random_cat_id

        return cat_unavailable_response if cat_id.nil?

        transmitter.edit_response(event:, text: cat_url(cat_id, text))
      end

      def cat_url(cat_id, text)
        return "#{URL}/#{cat_id}?#{rand(CACHE_INVALIDATION_VALUE)}" if text.nil?

        "#{URL}/#{cat_id}/says/#{encoded_text(text)}?#{rand(CACHE_INVALIDATION_VALUE)}"
      end

      def encoded_text(text)
        CGI.escape(text).tr('+', '%20')
      end

      def cat_unavailable_response
        transmitter.edit_response(event:, text: t('commands.public.cat.cat_unavailable'))
        transmitter.delete_response(event:)
      rescue StandardError => e
        logger.error(message: "Failed to send cat error response: #{e.class}: #{e.message}")
      end

      def text_too_long_response
        transmitter.error_response(event:,
                                   text: t(
                                     'commands.public.cat.text_too_long', { max_length: MAX_TEXT_LENGTH }
                                   ))
      end

      def too_many_words_response
        transmitter.error_response(event:, text: t('commands.public.cat.too_many_words'))
      end
    end
  end
end
