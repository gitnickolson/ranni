# frozen_string_literal: true

module Commands
  class ParentCommand < Command
    SUBCOMMANDS = [].freeze

    def register
      astra.register_application_command(self.class::NAME, self.class::DESCRIPTION,
                                         server_id:) do |command|
        register_subcommands(command)
      end
    end

    def call
      subcommand_instances.map(&:call)
    end

    private

    def register_subcommands(command)
      subcommand_instances.each do |instance|
        instance.register(discordrb_parent_command: command)
      end
    end

    def subcommand_instances
      @subcommand_instances ||= self.class::SUBCOMMANDS.map do |subcommand|
        subcommand.new(parent_command: self, astra:, server_id:, dependency_container:)
      end
    end
  end
end
