# frozen_string_literal: true

require 'discordrb'

class Astra
  def initialize
    @astra = Discordrb::Bot.new(token: ENV.fetch('TOKEN'))
    @running = false
  end

  def start
    # server_id = ENV.fetch('SERVER_ID').to_i

    astra.ready do
      next if @running

      @running = true
    end

    astra.run
  end

  private

  attr_reader :astra, :running
end
