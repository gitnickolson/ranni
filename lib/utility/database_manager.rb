# frozen_string_literal: true

require 'sequel'

module Utility
  class DatabaseManager
    class << self
      def create
        with_postgres_system_db do |db|
          if database_exists?(db)
            warn "Database #{db_name} already exists"
          else
            db.execute("CREATE DATABASE \"#{db_name}\"")
            puts "Database #{db_name} successfully created"
          end
        end
      end

      def drop
        with_postgres_system_db do |db|
          if database_exists?(db)
            db.execute("DROP DATABASE \"#{db_name}\" WITH (FORCE)")
            puts "Database #{db_name} successfully dropped"
          else
            warn "Database #{db_name} not found"
          end
        end
      end

      def migrate(args)
        run_migration(args[:version]&.to_i)
      end

      private

      def run_migration(target = nil)
        require 'sequel'
        require './lib/config/initializer'
        Sequel.extension :migration

        directory = 'migrations'

        return warn 'No migration files found' unless Dir.exist?(directory) && !Dir.empty?(directory)

        puts "Migrating to #{target ? "version #{target}" : 'latest'}"
        with_postgres_app_db do |db|
          Sequel::Migrator.run(db, directory, target:)
          puts "Database #{db_name} successfully migrated"
        end
      end

      def with_postgres_system_db(&)
        root_url = Utility::EnvironmentFetcher.postgres_url.gsub(%r{/[^/]+$}, '/postgres')
        Sequel.connect(root_url, &)
      end

      def with_postgres_app_db(&)
        Sequel.connect(Utility::EnvironmentFetcher.postgres_url, &)
      end

      def database_exists?(database)
        database[:pg_database].where(datname: db_name).any?
      end

      def db_name
        Utility::EnvironmentFetcher.database_name
      end
    end
  end
end
