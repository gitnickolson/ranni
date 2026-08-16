# frozen_string_literal: true

module Validation
  class RanksValidator
    include Translations::Translatable

    def initialize(server_service:)
      @server_service = server_service
    end

    def validate_creation(role_id:, required_level:)
      unless repository.find_by_role(role_id:).nil?
        return Utility::Result.failure(error: t('validation.ranks_validator.rank_for_role_already_exists'))
      end

      unless repository.find_by_level(required_level:).nil?
        return Utility::Result.failure(error: t('validation.ranks_validator.rank_for_level_already_exists'))
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
