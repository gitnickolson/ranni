# frozen_string_literal: true

module Commands
  class Subcommand < Command
    NAME = :subcommand
    DESCRIPTION = 'Subcommand description.'

    def initialize(parent_command:, bot:, server_id:, dependency_container:)
      @parent_command = parent_command
      super(bot:, server_id:, dependency_container:)
    end

    def register(discordrb_parent_command:)
      discordrb_parent_command.subcommand(self.class::NAME, self.class::DESCRIPTION)
    end

    def call
      bot.application_command(parent_command.class::NAME).subcommand(self.class::NAME) do |event|
        handle_event(event)
      end
    end

    private

    attr_reader :parent_command
  end
end
