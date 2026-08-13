# frozen_string_literal: true

module Repositories
  class RolesRepository
    def initialize(server_service:)
      @server_service = server_service
    end

    def role_exists?(role_id:)
      !role_from_id(role_id:).nil?
    end

    def role_from_id(role_id:)
      roles.find { |role| role.id == role_id.to_i }
    end

    private

    attr_reader :server_service

    def roles
      server_service.server.roles
    end
  end
end
