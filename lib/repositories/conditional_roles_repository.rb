# frozen_string_literal: true

module Repositories
  class ConditionalRolesRepository
    ENTITY = Models::ConditionalRole

    def initialize(server_service:)
      @server_service = server_service
    end

    def all
      ENTITY.where(server_id:).all
    end

    def find_by_role(role_id:)
      ENTITY.where(role_id: role_id.to_s, server_id:).first
    end

    def create(role_id:, condition:)
      ENTITY.create(role_id: role_id.to_s, condition:, server_id:)
    end

    def delete(role_id:)
      ENTITY.where(role_id: role_id.to_s, server_id:).delete
    end

    private

    attr_reader :server_service

    def server_id
      server_service.server.id.to_s
    end
  end
end
