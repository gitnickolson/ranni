# frozen_string_literal: true

require 'zeitwerk'

module Config
  class ZeitwerkInitializer
    class << self
      def call
        loader = Zeitwerk::Loader.new
        loader.push_dir(File.expand_path('../../lib', __dir__))
        loader.setup
      end
    end
  end
end
