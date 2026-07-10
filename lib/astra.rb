# frozen_string_literal: true

require 'discordrb'

class Bot
  def initialize
    @bot = Discordrb::Bot.new(token: ENV.fetch('TOKEN'))
    @running = false
  end

  def start
    server_id = ENV.fetch('SERVER_ID').to_i

    bot.ready do
      next if @running

      initialize_commands(server_id)
      @running = true
    end

    bot.run
  end

  private

  attr_reader :bot, :running

  def initialize_commands(server_id)
    command_manager = Utility::CommandManager.new(bot:, server_id:)
    command_manager.register_commands
    command_manager.call_commands
  end
end
