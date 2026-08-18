# frozen_string_literal: true

require 'discordrb'
require 'tzinfo'

class Bot
  def initialize
    @bot = Discordrb::Bot.new(token: ENV.fetch('TOKEN'), name: 'Ranni')
    @running = false
  end

  def start(args: nil)
    bot.ready do
      next if @running

      unregister_flag_set?(args) ? unregister_commands(args) : initialize_commands
      initialize_leveling

      @running = true
    end

    register_events

    bot.run
  end

  private

  attr_reader :bot, :running

  def initialize_commands
    command_manager.register_commands
    command_manager.enable_commands
  end

  def initialize_leveling
    leveling_initializer = Features::Leveling::LevelingInitializer.new(bot:)
    leveling_initializer.call
  end

  def register_events
    event_manager = Utility::EventManager.new(bot:)
    event_manager.register_events
  end

  def unregister_flag_set?(args)
    args[0]&.downcase == '--unregister'
  end

  def unregister_commands(args)
    args.delete_at(0)
    command_manager.unregister_commands(names: args)
  end

  def command_manager
    @command_manager ||= Utility::CommandManager.new(bot:)
  end
end
