# frozen_string_literal: true

module Commands
  module Registerable
    DISCORD_LOCALES = %w[en-US en-GB de].freeze
    ENGLISH_LOCALES = %w[en-US en-GB].freeze
    SUPPORTED_ENGLISH_LOCALE = 'en'

    def register(bot:)
      bot.register_application_command(self::NAME, self::DESCRIPTION,
                                       description_localizations: command_localizations) do |command|
        register_parameters(command)
      end
    end

    def register_parameters(command)
      self::PARAMETERS.each do |parameter|
        command.send(parameter[:type], parameter[:name], parameter[:description], **parameter_options(parameter))
      end
    end

    def parameter_options(parameter)
      options = {
        required: parameter[:required],
        description_localizations: parameter_localizations(parameter)
      }
      options[:choices] = parameter[:choices] if parameter[:type] == :string
      options
    end

    def command_localizations
      DISCORD_LOCALES.to_h do |locale|
        [locale,
         Translations::KeyTranslator.translate_command_description(
           command_path: translation_path,
           locale: locale == ENGLISH_LOCALES.include?(locale) ? SUPPORTED_ENGLISH_LOCALE : locale,
           fallback_description: self::DESCRIPTION
         )]
      end
    end

    def parameter_localizations(parameter)
      DISCORD_LOCALES.to_h do |locale|
        [locale,
         Translations::KeyTranslator.translate_parameter_description(
           command_path: translation_path,
           parameter_name: parameter[:name],
           locale: locale == ENGLISH_LOCALES.include?(locale) ? SUPPORTED_ENGLISH_LOCALE : locale,
           fallback_description: parameter[:description]
         )]
      end
    end

    def listen(bot:)
      bot.application_command(self::NAME) do |event|
        command = new(bot:, event:)
        command.handle_event
      end
    end

    def translation_path
      name.split('::')[1..]
          .map { |part| part.gsub(/([a-z\d])([A-Z])/, '\1_\2').downcase.to_sym }
          .chunk_while { |current_segment, next_segment| current_segment == next_segment }
          .map(&:first)
    end
  end
end
