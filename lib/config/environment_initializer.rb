# frozen_string_literal: true

require 'dotenv'

module Config
  class EnvironmentInitializer
    class << self
      def call
        project_root = File.expand_path('../../', __dir__)

        environment = ENV['ENV']&.downcase
        env_path = environment == 'production' ? File.join(project_root, '.env') : File.join(project_root, '.env.test')

        Dotenv.load(env_path)

        env_message = "Loading env from: #{env_path}"

        logger = Utility::Logger.instance
        logger.info(message: env_message)
      end
    end
  end
end
