# frozen_string_literal: true

module Commands
  class ParentCommand < Command
    NAME = :parent_command
    DESCRIPTION = 'Parent command description.'
    SUBCOMMANDS = [].freeze

    def self.register(bot:)
      t = { 'de' => Translations::KeyTranslator.translate_command_description(command_name: self::NAME, locale: 'de',
                                                                              fallback_description: self::DESCRIPTION) }

      bot.register_application_command(self::NAME, self::DESCRIPTION, description_localizations: t) do |command|
        self::SUBCOMMANDS.each { it.register(discordrb_parent_command: command) }
      end
    end

    def self.listen(bot:)
      self::SUBCOMMANDS.map { it.listen(bot:, parent_command: self) }
    end
  end
end
