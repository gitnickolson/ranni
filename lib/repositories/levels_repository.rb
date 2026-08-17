# frozen_string_literal: true

module Repositories
  class LevelsRepository
    def initialize(server_service:)
      @server_service = server_service
    end

    def all(active: true)
      levels = Models::Level.where(server_id:).order(:numeric).all

      return levels unless active

      levels.select { server_service.user_ids.include?(it.user_id.to_i) }
    end

    def find_by_user_id(user_id:)
      level = Models::Level.where(server_id:, user_id: user_id.to_s).first

      return level unless level.nil?

      Models::Level.create(user_id:, server_id:)
    end

    def update_numeric(user_id:, numeric:)
      numeric = server_service.max_level if numeric > server_service.max_level

      Models::Level.update_or_create(
        { server_id:, user_id: user_id.to_s },
        numeric:,
        experience_points: xp_from_numeric(numeric)
      )
    end

    def update_xp(user_id:, experience_points:)
      Models::Level.update_or_create(server_id:, user_id: user_id.to_s) do |level|
        total_xp = (level.experience_points || 0) + experience_points
        total_xp = max_xp if total_xp > max_xp

        level.set(numeric: numeric_from_xp(total_xp), experience_points: total_xp)
      end
    end

    def required_xp_for(level_numeric:)
      return max_xp if level_numeric > max_xp

      (level_numeric * (level_numeric + 1) / 2) * 100
    end

    private

    attr_reader :server_service

    def server_id
      server_service.server.id.to_s
    end

    def numeric_from_xp(experience_points)
      ((Math.sqrt(1 + (8 * experience_points / 100.0)) - 1) / 2).floor
    end

    def xp_from_numeric(numeric)
      (((((2 * numeric) + 1)**2) - 1) * 100 / 8).to_i
    end

    def max_xp
      (xp_from_numeric(server_service.max_level + 1) - 1)
    end
  end
end
