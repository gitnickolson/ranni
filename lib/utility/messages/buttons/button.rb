# frozen_string_literal: true

module Utility
  module Messages
    module Buttons
      class Button
        VALID_STYLES = [1, 2, 3, 4].freeze

        def initialize(custom_id:, label:, style:, disabled: false, handler: nil, &block)
          raise ArgumentError, "Invalid style: #{style}" unless VALID_STYLES.include?(style)
          raise ArgumentError, 'custom_id is required' if custom_id.nil?

          @custom_id = custom_id
          @label = label
          @style = style
          @disabled = disabled
          @handler = block || handler
        end

        attr_reader :custom_id, :label, :style, :handler

        def disabled?
          disabled
        end

        private

        attr_reader :disabled
      end
    end
  end
end
