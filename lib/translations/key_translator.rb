# frozen_string_literal: true

require 'locale'

module Translations
  class KeyTranslator
    def initialize(server_service:)
      @server_service = server_service
    end

    def translate(key, params = {})
      fields = key.split('.').map(&:to_sym)
      value = translations.dig(*fields)
      interpolate(value, params)
    rescue StandardError
      puts "Translation key not found: #{key}"
    end

    private

    attr_reader :server_service

    def interpolate(value, params)
      return value unless value.is_a?(String) && params.any?

      value.gsub(/%?\{(\w+)\}/) do
        param_key = Regexp.last_match(1).to_sym
        params.key?(param_key) ? params[param_key].to_s : Regexp.last_match(0)
      end
    end

    def translations
      locale = preferences_repository.locale
      Utility::FileAccess::JsonReader.call(filepath: "locales/#{locale}")
    end

    def preferences_repository
      @preferences_repository ||= Repositories::PreferencesRepository.new(server_id: server_service.server.id)
    end
  end
end
