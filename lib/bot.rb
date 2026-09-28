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
      next if running

      unregister_flag_set?(args) ? unregister_commands(args) : initialize_commands
      initialize_leveling
      initialize_servers
      initialize_button_registry
      initialize_misc

      @running = true
    end

    bot.run
  end

  private

  attr_accessor :running
  attr_reader :bot

  def initialize_commands
    command_manager.register_commands
    command_manager.enable_commands
  end

  def initialize_leveling
    leveling_initializer = Features::Leveling::LevelingInitializer.new(bot:)
    leveling_initializer.call
  end

  def initialize_servers
    event_manager = Utility::EventManager.new(bot:)

    bot.servers.each_key do |server_id|
      server_service = Utility::ServerService.new(bot:, server_id:)

      event_manager.register_server_specific_events(server_service:)

      ticket_button_refresher = Utility::Tickets::TicketButtonRefresher.new(server_service:)
      ticket_button_refresher.call
    end

    event_manager.register_global_events
  end

  def initialize_button_registry
    Utility::Messages::Buttons::ButtonRegistry.instance.setup(bot:)
  end

  def initialize_misc
    Status::StatusUpdater.call(bot:)
    voice_join_preventer = Utility::VoiceJoinPreventer.new(bot:)
    voice_join_preventer.call
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
