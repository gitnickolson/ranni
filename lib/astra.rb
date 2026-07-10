# frozen_string_literal: true

require 'discordrb'

class Astra
  def initialize
    @astra = Discordrb::Bot.new(token: ENV.fetch('TOKEN'))
    @running = false
  end

  def start
    server_id = ENV.fetch('SERVER_ID').to_i

    astra.ready do
      next if @running

      initialize_commands(server_id)
      @running = true
    end

    astra.run
  end

  private

  attr_reader :astra, :running

  def initialize_commands(server_id)
    command_manager = Utility::CommandManager.new(astra:, server_id:)
    command_manager.register_commands
    command_manager.call_commands
  end
end
