# frozen_string_literal: true

require 'sequel'
require 'uri'

module Utility
  class DatabaseManager
    MIGRATIONS_DIRECTORY = 'migrations'

    class << self
      def create
        with_postgres_system_db do |db|
          if database_exists?(db)
            warn "Database #{db_name} already exists"
          else
            db.run("CREATE DATABASE #{db.quote_identifier(db_name)}")
            puts "Database #{db_name} successfully created"
          end
        end
      end

      def drop
        abort 'Refusing to drop a database in production' if production?

        with_postgres_system_db do |db|
          if database_exists?(db)
            db.run("DROP DATABASE #{db.quote_identifier(db_name)} WITH (FORCE)")
            puts "Database #{db_name} successfully dropped"
          else
            warn "Database #{db_name} not found"
          end
        end
      end

      def migrate(args)
        version = args[:version]
        target = version.to_s.empty? ? nil : Integer(version)
        run_migration(target)
      end

      private

      def run_migration(target = nil)
        unless Dir.exist?(MIGRATIONS_DIRECTORY) && !Dir.empty?(MIGRATIONS_DIRECTORY)
          return warn 'No migration files found'
        end

        Sequel.extension(:migration)

        puts "Migrating to #{target ? "version #{target}" : 'latest'}"
        with_postgres_app_db do |db|
          Sequel::Migrator.run(db, MIGRATIONS_DIRECTORY, target:)
          puts "Database #{db_name} successfully migrated"
        end
      end

      def with_postgres_system_db(&)
        uri = URI.parse(Utility::EnvironmentFetcher.postgres_url)
        uri.path = '/postgres'
        Sequel.connect(uri.to_s, &)
      end

      def with_postgres_app_db(&)
        Sequel.connect(Utility::EnvironmentFetcher.postgres_url, &)
      end

      def database_exists?(database)
        !database[:pg_database].where(datname: db_name).empty?
      end

      def db_name
        Utility::EnvironmentFetcher.database_name
      end

      def production?
        ENV['ENV'].to_s.strip.downcase == 'production'
      end
    end
  end
end
