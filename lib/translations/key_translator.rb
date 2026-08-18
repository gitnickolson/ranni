# frozen_string_literal: true

module Translations
  class KeyTranslator
    def self.translate_command_description(command_path:, locale:, fallback_description:)
      translations = Utility::FileAccess::JsonReader.call(filepath: "locales/#{locale}")
      translations.dig(:commands, *command_path, :description) || fallback_description
    rescue StandardError
      fallback_description
    end

    def self.translate_parameter_description(command_path:, parameter_name:, locale:, fallback_description:)
      translations = Utility::FileAccess::JsonReader.call(filepath: "locales/#{locale}")
      translations.dig(:commands, *command_path, :parameters, parameter_name.to_sym,
                       :description) || fallback_description
    rescue StandardError
      fallback_description
    end

    def initialize(server_service:)
      @server_service = server_service
    end

    def translate(key, parameters = {})
      fields = key.split('.').map(&:to_sym)
      value = translations.dig(*fields)
      interpolate(value, parameters) || key
    rescue StandardError
      logger.error(message: "Translation error occured for key: #{key}")
      key
    end

    private

    attr_reader :server_service

    def interpolate(value, parameters)
      return value unless value.is_a?(String) && parameters.any?

      value.gsub(/%?\{(\w+)\}/) do
        param_key = Regexp.last_match(1).to_sym
        parameters.key?(param_key) ? parameters[param_key].to_s : Regexp.last_match(0)
      end
    end

    def translations
      locale = server_service.locale
      Utility::FileAccess::JsonReader.call(filepath: "locales/#{locale}")
    end

    def logger
      @logger ||= Utility::Logger.instance
    end
  end
end
