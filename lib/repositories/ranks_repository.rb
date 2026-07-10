# frozen_string_literal: true

module Repositories
  class RanksRepository
    class << self
      def all
        Models::Rank.order(:required_level).all
      end

      def find_by_role(role_id:)
        Models::Rank.where(role_id: role_id.to_s).first
      end

      def find_by_level(required_level:)
        Models::Rank.where(required_level:).first
      end

      def create(role_id:, required_level:)
        Models::Rank.create(role_id: role_id.to_s, required_level:)
      end

      def delete(role_id:)
        Models::Rank.where(role_id: role_id.to_s).delete
      end
    end
  end
end
