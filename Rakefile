# frozen_string_literal: true

require 'rake'
require 'rubocop/rake_task'
require 'sequel'
require './lib/config/initializer'

Config::Initializer.call

RuboCop::RakeTask.new

Dir.glob('lib/tasks/*.rake') { |file| import file }
task default: :rubocop
