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

      initialize_commands

      @running = true
    end

    initialize_leveling

    bot.run
  end

  private

  attr_reader :bot, :running

  def initialize_commands
    command_manager = Utility::CommandManager.new(bot:)

    command_manager.register_commands
    command_manager.enable_commands
  end

  def initialize_leveling
    leveling_initializer = Features::Leveling::LevelingInitializer.new(bot:)
    leveling_initializer.call
  end
end
