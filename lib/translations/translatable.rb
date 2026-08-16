# frozen_string_literal: true

module Translations
  module Translatable
    def t(key, parameters = {})
      key_translator.translate(key, parameters)
    end

    def key_translator
      @key_translator ||= Translations::KeyTranslator.new(server_service:)
    end
  end
end
