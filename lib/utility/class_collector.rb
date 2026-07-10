# frozen_string_literal: true

module Utility
  class ClassCollector
    def self.all_classes_under(mod:)
      mod.constants.flat_map do |const_name|
        const = mod.const_get(const_name)

        next const if const.is_a?(Class)
        next all_classes_under(mod: const) if const.is_a?(Module)

        []
      end
    end
  end
end
