# frozen_string_literal: true

module Utility
  class CommandManager
    COMMAND_INTERACTION_SLEEP_TIME = 2

    def initialize(bot:, server_id:)
      @bot = bot
      @server_id = server_id

      permission_checker = PermissionChecker.new(bot:, server_id:)
      dependency_container = Commands::DependencyContainer.new(logger:,
                                                               message_transmitter: Messages::MessageTransmitter,
                                                               permission_checker:)

      @command_instances = all_commands.map do |command|
        command.new(bot:, server_id:, dependency_container:)
      end
    end

    def register_commands
      unregistered_commands = all_commands.reject { command_already_registered?(it) }

      return if unregistered_commands.empty?

      unregistered_commands.each do |command|
        command_instance = command_instances.find { |command_instance| command_instance.instance_of?(command) }
        command_instance.register
        logger.log_info_and_print(message: "#{command::NAME} registered")

        sleep COMMAND_INTERACTION_SLEEP_TIME
      end

      'Successfully registered all unregistered commands!'
    end

    def call_commands
      command_instances.each(&:call)
    end

    def all_commands
      @all_commands ||= begin
        commands = all_command_classes.reject do |command|
          command < Commands::Subcommand
        end
        commands.sort_by { |command_class| command_class::NAME }
      end
    end

    # This method exists because I need to unregister registered application commands occasionally
    def unregister_commands(names: [])
      return unregister_all_commands if names.empty?

      unregister_filtered_commands(names)
    end

    private

    attr_reader :bot, :command_instances, :server_id

    def command_already_registered?(command)
      registered_application_commands.map(&:name).include?(command::NAME.to_s)
    end

    def unregister_all_commands
      logger.log_info_and_print(message: 'Unregistering all commands...')

      registered_application_commands.each do |command|
        sleep COMMAND_INTERACTION_SLEEP_TIME

        bot.delete_application_command(command.id, server_id:)
        logger.log_info_and_print(message: "#{command.name} unregistered")
      end

      logger.log_info_and_print(message: 'Successfully unregistered commands!')
    end

    def unregister_filtered_commands(names)
      logger.log_info_and_print(message: "Unregistering commands with filters: #{names}")

      registered_application_commands.each do |command|
        next unless names.include?(command.name)

        sleep COMMAND_INTERACTION_SLEEP_TIME

        bot.delete_application_command(command.id, server_id:)
        logger.log_info_and_print(message: "#{command.name} unregistered")
      end

      logger.log_info_and_print(message: 'Successfully unregistered commands!')
    end

    def registered_application_commands
      @registered_application_commands ||= bot.get_application_commands(server_id:)
    end

    def all_command_classes
      Utility::ClassCollector.all_classes_under(mod: Commands::Administrator) # +
      # Utility::ClassCollector.all_classes_under(mod: Commands::Booster) +
      # Utility::ClassCollector.all_classes_under(mod: Commands::Public)
    end

    def logger
      Utility::Logger.instance
    end
  end
end
