# frozen_string_literal: true

module Utility
  class PermissionChecker
    def initialize(astra:, server_id:)
      @astra = astra
      @server_id = server_id
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

    attr_reader :astra, :server_id

    def member_for(user)
      server.members.find { |member| member.id == user.id }
    end

    def server
      astra.servers[server_id]
    end
  end
end
