# frozen_string_literal: true

module Utility
  class EmptyChannelDeleter
    class << self
      ONE_MINUTE = 60

      def call(channel:)
        Thread.new do
          loop do
            sleep ONE_MINUTE

            break channel.delete if channel.users.empty?
          end
        rescue Discordrb::Errors::UnknownChannel => e
          Utility::Logger.instance.info(message: "Channel deleted prematurely: #{e}")
        end
      end
    end
  end
end
