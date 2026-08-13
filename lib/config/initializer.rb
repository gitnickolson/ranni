# frozen_string_literal: true

require 'sequel'
require './lib/config/zeitwerk_initializer'

module Config
  class Initializer
    class << self
      def call
        ZeitwerkInitializer.call
        EnvironmentInitializer.call

        Sequel::Model.plugin(:update_or_create)
      end
    end
  end
end
