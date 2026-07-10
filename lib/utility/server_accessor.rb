# frozen_string_literal: true

module Utility
  class ServerAccessor
    DEFAULT_COLOR_CODE = '#7022ff'

    def initialize(bot:, server_id:)
      @bot = bot
      @server_id = server_id
    end

    def self.server_color_code
      DEFAULT_COLOR_CODE
    end

    def role_exists?(role_id:)
      !role_from_id(role_id:).nil?
    end

    def role_from_id(role_id:)
      roles.find { |role| role.id == role_id }
    end

    private

    attr_reader :bot, :server_id

    def roles
      server.roles
    end

    def server
      bot.servers[server_id]
    end
  end
end
