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

      private

      def command_action
        text = event.options['text']

        return transmitter.response(event:, text: "https://cataas.com/cat/gif?#{rand(100_000_0)}") if text.nil?

        return too_many_words_response if text.split.length > MAX_WORDS
        return text_too_long_response if text.length > MAX_TEXT_LENGTH

        cat_id = Clients::CataasClient.random_cat_id
        transmitter.response(event:, text: "https://cataas.com/cat/#{cat_id}/says/#{text}?#{rand(100_000_0)}")
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
