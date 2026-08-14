# frozen_string_literal: true

module Commands
  class DependencyContainer
    def initialize(logger:, message_transmitter:, permission_checker:)
      @logger = logger
      @message_transmitter = message_transmitter
      @permission_checker = permission_checker
    end

    attr_reader :logger, :message_transmitter, :permission_checker
  end
end
