# frozen_string_literal: true

require 'dotenv'

module Config
  class EnvironmentInitializer
    class << self
      PROJECT_ROOT = File.expand_path('../../', __dir__)

      def call
        env_path = File.join(PROJECT_ROOT, env_file_name)

        Dotenv.load!(env_path)
        Utility::Logger.instance.info(message: "Loading env from: #{env_path}")
      end

      private

      def env_file_name
        env = ENV['ENV'].to_s.strip.downcase
        env.empty? ? '.env' : ".env.#{env}"
      end
    end
  end
end
