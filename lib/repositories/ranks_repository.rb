# frozen_string_literal: true

module Repositories
  class RanksRepository
    ENTITY = Models::Rank

    def initialize(server_service:)
      @server_service = server_service
    end

    def all
      ENTITY.where(server_id:).order(:required_level).all
    end

    def find_by_role(role_id:)
      ENTITY.where(role_id: role_id.to_s, server_id:).first
    end

    def find_by_level(required_level:)
      ENTITY.where(required_level:, server_id:).first
    end

    def find_current_for_level(level:)
      ENTITY
        .where(server_id:)
        .where { required_level <= level }
        .order(:required_level)
        .last
    end

    def create(role_id:, required_level:)
      ENTITY.create(role_id: role_id.to_s, required_level:, server_id:)
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
