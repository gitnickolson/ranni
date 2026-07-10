# frozen_string_literal: true

require 'rake'
require 'rubocop/rake_task'
require 'rspec/core/rake_task'
require 'sequel'
require './lib/config/initializer'

Config::Initializer.call

RuboCop::RakeTask.new
RSpec::Core::RakeTask.new(:spec)

Dir.glob('lib/tasks/*.rake') { |file| import file }
task default: %i[spec rubocop]
