# frozen_string_literal: true

module Validation
  class RanksValidator
    def initialize(server_service:)
      @server_service = server_service
    end

    def validate_creation(role_id:, required_level:)
      unless repository.find_by_role(role_id:).nil?
        return Utility::Result.failure(error: 'Ein Rang mit dieser Rolle existiert schon.')
      end

      unless repository.find_by_level(required_level:).nil?
        return Utility::Result.failure(error: 'Ein Rang für dieses Level existiert schon.')
      end

      Utility::Result.ok
    end

    private

    attr_reader :server_service

    def repository
      @repository ||= Repositories::RanksRepository.new(server_service:)
    end
  end
end
