# frozen_string_literal: true

require 'singleton'

module Utility
  module Messages
    module Buttons
      class ButtonRegistry
        REAPING_INTERVAL = 60

        include Singleton

        def initialize
          @button_handlers = {}
          @button_expiries = {}
          @mutex = Mutex.new
        end

        def setup(bot:)
          @bot = bot

          @bot.button do |event|
            dispatch(event)
          end

          start_reaper
        end

        def register(custom_id:, ttl:, &handler)
          @mutex.synchronize do
            @button_handlers[custom_id] = handler
            @button_expiries[custom_id] = Time.now + ttl unless ttl == Utility::Messages::Buttons::Button::INFINITE_TTL
          end
        end

        def unregister(custom_id:)
          @mutex.synchronize do
            @button_handlers.delete(custom_id)
            @button_expiries.delete(custom_id)
          end
        end

        private

        def dispatch(event)
          custom_id = event.interaction.button.custom_id
          handler = @mutex.synchronize { @button_handlers[custom_id] }
          handler&.call(event)
        end

        def start_reaper
          return if @reaper

          @reaper = Thread.new do
            loop do
              sleep REAPING_INTERVAL
              reap_expired_buttons
            end
          end
        end

        def reap_expired_buttons
          now = Time.now

          @mutex.synchronize do
            expired = @button_expiries.select { |_custom_id, expires_at| expires_at <= now }.keys
            expired.each do |custom_id|
              @button_handlers.delete(custom_id)
              @button_expiries.delete(custom_id)
            end
          end
        end
      end
    end
  end
end
