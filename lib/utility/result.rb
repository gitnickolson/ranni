# frozen_string_literal: true

module Utility
  class Result
    class << self
      def ok(value: nil)
        new(success: true, value: value)
      end

      def failure(error: nil)
        new(success: false, value: error)
      end
    end

    attr_reader :value

    def ok?
      success
    end

    def failure?
      !success
    end

    private

    attr_reader :success

    def initialize(success:, value:)
      @success = success
      @value = value
    end
  end
end
