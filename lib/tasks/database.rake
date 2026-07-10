# frozen_string_literal: true

require 'rake'

namespace :db do
  desc 'Create database'
  task :create do
    Utility::DatabaseManager.create
  end

  desc 'Drop database'
  task :drop do
    Utility::DatabaseManager.drop
  end

  desc 'Run database migrations'
  task :migrate, %i[version] do |_, args|
    Utility::DatabaseManager.migrate(args)
  end
end
