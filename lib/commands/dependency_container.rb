# frozen_string_literal: true

module Commands
  class DependencyContainer
    def initialize(server_service:, logger:, message_transmitter:, permission_checker:)
      @server_service = server_service
      @logger = logger
      @message_transmitter = message_transmitter
      @permission_checker = permission_checker
    end

    attr_reader :server_service, :logger, :message_transmitter, :permission_checker
  end
end
