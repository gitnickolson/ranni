# frozen_string_literal: true

module Utility
  module Messages
    module Embeds
      class EmbedField
        def initialize(name: '', value: '', inlined: false)
          @name = name || ''
          @value = value || ''
          @inlined = inlined
        end

        def inlined?
          inlined
        end

        attr_reader :name, :value

        private

        attr_reader :inlined
      end
    end
  end
end
