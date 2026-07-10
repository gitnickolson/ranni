# frozen_string_literal: true

ENV['ENV'] = 'test'

require 'database_cleaner-sequel'
require 'discordrb'
require 'factory_bot'
require 'rspec'
require 'sequel'
require 'simplecov'
require 'timecop'

require './lib/config/initializer'

class SpecHelper
  class << self
    def set_up_simplecov
      SimpleCov.minimum_coverage 100
      SimpleCov.start do
        add_filter '/spec/'
        enable_coverage :branch
      end
    end

    def configure_rspec
      RSpec.configure do |config|
        config.include FactoryBot::Syntax::Methods
        config.color = true
        config.disable_monkey_patching!

        configure_around(config)
        configure_before(config)
        configure_after(config)
      end
    end

    private

    def configure_before(config)
      config.before(:suite) do
        FactoryBot.find_definitions
        DatabaseCleaner[:sequel].strategy = :transaction
        DatabaseCleaner[:sequel].clean_with(:truncation)
      end
    end

    def configure_around(config)
      config.around { |example| DatabaseCleaner[:sequel].cleaning { example.run } }
    end

    def configure_after(config)
      config.after { Timecop.unfreeze }
    end
  end
end

Config::Initializer.call
DB = Sequel.connect(Utility::EnvironmentFetcher.postgres_url)
SpecHelper.set_up_simplecov
SpecHelper.configure_rspec
