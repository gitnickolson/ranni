# frozen_string_literal: true

module Commands
  class Subcommand < Command
    NAME = :subcommand
    DESCRIPTION = 'Subcommand description.'

    def self.register(discordrb_parent_command:)
      t = { 'de' => Translations::KeyTranslator.translate_command_description(command_name: self::NAME, locale: 'de',
                                                                              fallback_description: self::DESCRIPTION) }

      discordrb_parent_command.subcommand(self::NAME, self::DESCRIPTION, description_localizations: t) do |command|
        register_parameters(command)
      end
    end

    def self.listen(bot:, parent_command:)
      bot.application_command(parent_command::NAME).subcommand(self::NAME) do |event|
        command = new(bot:)
        command.handle_event(event)
      end
    end
  end
end
