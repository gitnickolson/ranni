# frozen_string_literal: true

module Commands
  class ParentCommand < Command
    SUBCOMMANDS = [].freeze

    def self.register(bot:)
      bot.register_application_command(self::NAME, self::DESCRIPTION) do |command|
        self::SUBCOMMANDS.each { it.register(discordrb_parent_command: command) }
      end
    end

    def self.listen(bot:)
      self::SUBCOMMANDS.map { it.listen(bot:, parent_command: self) }
    end
  end
end
