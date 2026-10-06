# frozen_string_literal: true

require 'dotenv'

module Config
  class EnvironmentInitializer
    class << self
      PROJECT_ROOT = File.expand_path('../../', __dir__)

      def call
        env_path = File.join(PROJECT_ROOT, env_file_name)

        if File.exist?(env_path)
          Dotenv.load(env_path)
          logger.info(message: "Loading env from: #{env_path}")
        else
          logger.info(message: "No env file at #{env_path}, using process environment")
        end
      end

      private

      def env_file_name
        environment = ENV['ENV'].to_s.strip.downcase
        environment.empty? ? '.env' : ".env.#{environment}"
      end

      def logger
        Utility::Logger.instance
      end
    end
  end
end
