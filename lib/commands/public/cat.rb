# frozen_string_literal: true

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

      private

      def command_action
        text = event.options['text']
        cat_id = Clients::CataasClient.random_cat_id

        if text.nil?
          return transmitter.response(event:, text: "https://cataas.com/cat/#{cat_id}?#{rand(CACHE_INVALIDATION_VALUE)}")
        end

        return too_many_words_response if text.split.length > MAX_WORDS
        return text_too_long_response if text.length > MAX_TEXT_LENGTH

        transmitter.response(event:, text: "https://cataas.com/cat/#{cat_id}/says/#{text}?#{rand(CACHE_INVALIDATION_VALUE)}")
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
