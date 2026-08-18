# frozen_string_literal: true

module Utility
  class CommandManager
    COMMAND_INTERACTION_SLEEP_TIME = 2

    def initialize(bot:)
      @bot = bot
    end

    def register_commands
      unregistered_commands = all_commands.reject { command_already_registered?(it) }

      return if unregistered_commands.empty?

      unregistered_commands.each do |command|
        command.register(bot:)
        logger.info(message: "#{command::NAME} registered")

        sleep COMMAND_INTERACTION_SLEEP_TIME
      end

      logger.info(message: 'Successfully registered all unregistered commands!')
    end

    def enable_commands
      all_commands.each { it.listen(bot:) }
    end

    def unregister_commands(names: [])
      return unregister_all_commands if names.empty?

      unregister_filtered_commands(names)
    end

    private

    attr_reader :bot

    def command_already_registered?(command)
      registered_application_commands.map(&:name).include?(command::NAME.to_s)
    end

    def unregister_all_commands
      logger.info(message: 'Unregistering all commands...')

      registered_application_commands.each do |command|
        sleep COMMAND_INTERACTION_SLEEP_TIME

        bot.delete_application_command(command.id)
        logger.info(message: "#{command.name} unregistered")
      end

      logger.info(message: 'Successfully unregistered commands!')
    end

    def unregister_filtered_commands(names)
      logger.info(message: "Unregistering commands with filters: #{names}")

      registered_application_commands.each do |command|
        next unless names.include?(command.name)

        sleep COMMAND_INTERACTION_SLEEP_TIME

        bot.delete_application_command(command.id)
        logger.info(message: "#{command.name} unregistered")
      end

      logger.info(message: 'Successfully unregistered commands!')
    end

    def registered_application_commands
      bot.get_application_commands
    end

    def all_commands
      @all_commands ||= begin
        commands = all_commands_and_subcommands.reject do |command|
          command < Commands::Subcommand
        end

        commands.sort_by { |command| command::NAME }
      end
    end

    def all_commands_and_subcommands
      Utility::ClassCollector.all_classes_under(mod: Commands::Administrator) +
        Utility::ClassCollector.all_classes_under(mod: Commands::Public) # +
      # Utility::ClassCollector.all_classes_under(mod: Commands::Booster) +
    end

    def logger
      Utility::Logger.instance
    end
  end
end
