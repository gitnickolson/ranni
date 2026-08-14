# frozen_string_literal: true

require 'discordrb'

class Bot
  def initialize
    @bot = Discordrb::Bot.new(token: ENV.fetch('TOKEN'), name: 'Ranni')
    @running = false
  end

  def start
    bot.ready do
      next if @running

      server_ids = bot.servers.keys
      server_ids.each { initialize_features_for(it) }

      @running = true
    end

    bot.run
  end

  private

  attr_reader :bot, :running

  def initialize_features_for(server_id)
    server_service = Utility::ServerService.new(bot:, server_id:)

    initialize_commands(server_service)
    initialize_leveling(server_service)
  end

  def initialize_commands(server_service)
    command_manager = Utility::CommandManager.new(bot:, server_service:)

    command_manager.register_commands
    command_manager.call_commands
  end

  def initialize_leveling(server_service)
    leveling_initializer = Features::Leveling::LevelingInitializer.new(bot:, server_service:)
    leveling_initializer.call
  end
end
