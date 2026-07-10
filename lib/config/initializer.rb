# frozen_string_literal: true

require 'sequel'
require './lib/config/zeitwerk_initializer'

module Config
  class Initializer
    class << self
      def call
        ZeitwerkInitializer.call
        EnvironmentInitializer.call
      end
    end
  end
end
