require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require "reevoocop/rake_task"
require "bundler/audit/task"

ReevooCop::RakeTask.new(:reevoocop)
RSpec::Core::RakeTask.new(:spec)
Bundler::Audit::Task.new

task default: %w(spec reevoocop bundle:audit)
