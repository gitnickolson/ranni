# frozen_string_literal: true

module Utility
  class PermissionChecker
    def initialize(bot:, server_service:)
      @bot = bot
      @server_service = server_service
    end

    def administrator?(user:)
      member = member_for(user)
      return false unless member

      member.permission?(:administrator)
    end

    def booster?(user:)
      member = member_for(user)
      return false unless member

      member.boosting?
    end

    private

    attr_reader :bot, :server_service

    def member_for(user)
      server_service.server.members.find { |member| member.id == user.id }
    end
  end
end
