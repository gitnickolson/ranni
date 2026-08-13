# frozen_string_literal: true

module Repositories
  class TextLevelsRepository
    def initialize(server_service:)
      @server_service = server_service
    end

    def all(active: true)
      levels = Models::TextLevel.where(server_id:).order(:numeric).all

      return levels unless active

      levels.select { server_service.user_ids.include?(it.user_id) }
    end

    def find_by_user_id(user_id:)
      Models::TextLevel.where(server_id:, user_id:).first
    end

    def update_numeric(user_id:, numeric:)
      numeric = preferences_repository.max_text_level if numeric > preferences_repository.max_text_level

      Models::TextLevel.where(server_id:, user_id:).update_or_create(numeric:,
                                                                     experience_points: xp_from_numeric(numeric))
    end

    def update_xp(user_id:, experience_points:)
      max_xp = (xp_from_numeric(preferences_repository.max_text_level + 1) - 1)
      experience_points = max_xp if experience_points > max_xp

      Models::TextLevel.where(server_id:, user_id:).update_or_create(numeric: numeric_from_xp(experience_points),
                                                                     experience_points:)
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

    def preferences_repository
      @preferences_repository ||= Repositories::PreferencesRepository.new(server_id: server_service.server.id)
    end
  end
end
