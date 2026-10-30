# frozen_string_literal: true

module Validation
  class ConditionalRolesValidator
    MAX_CONDITION_LENGTH = 100

    include Translations::Translatable

    def initialize(server_service:)
      @server_service = server_service
    end

    def validate_creation(role_id:, condition:)
      unless repository.find_by_role(role_id:).nil?
        return Utility::Result.failure(error:
          t('validation.conditional_roles_validator.conditional_role_for_role_already_exists'))
      end

      if condition.length > MAX_CONDITION_LENGTH
        return Utility::Result.failure(error: t('validation.conditional_roles_validator.condition_too_long'))
      end

      Utility::Result.ok
    end

    private

    attr_reader :server_service

    def repository
      @repository ||= Repositories::ConditionalRolesRepository.new(server_service:)
    end
  end
end
