# frozen_string_literal: true

module Models
  class Level < Sequel::Model(:levels)
    BASELINE_LEVEL = 80
    BASELINE_COST  = 100 * (BASELINE_LEVEL + 1)
    DEFAULT_MULTIPLIER = 1

    def multiplier
      return DEFAULT_MULTIPLIER if numeric < 120

      (numeric + 1) / BASELINE_COST.fdiv(100)
    end
  end
end
