# frozen_string_literal: true

module Repositories
  class RanksRepository
    def initialize(server_service:)
      @server_service = server_service
    end

    def all
      Models::Rank.order(:required_level, server_id:).all
    end

    def find_by_role(role_id:)
      Models::Rank.where(role_id: role_id.to_s, server_id:).first
    end

    def find_by_level(required_level:)
      Models::Rank.where(required_level:, server_id:).first
    end

    def create(role_id:, required_level:)
      Models::Rank.create(role_id: role_id.to_s, required_level:, server_id:)
    end

    def delete(role_id:)
      Models::Rank.where(role_id: role_id.to_s, server_id:).delete
    end

    private

    attr_reader :server_service

    def server_id
      server_service.server.id.to_s
    end
  end
end
