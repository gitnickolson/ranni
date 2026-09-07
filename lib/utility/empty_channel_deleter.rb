# frozen_string_literal: true

module Utility
  class EmptyChannelDeleter
    class << self
      ONE_MINUTE = 60

      def call(channel:)
        Thread.new do
          loop do
            break channel.delete if channel.users.empty?

            sleep ONE_MINUTE
          end
        end
      end
    end
  end
end
