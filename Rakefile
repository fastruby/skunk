# frozen_string_literal: true

require "bundler/gem_tasks"
require "rake/testtask"
require "reek/rake/task"
require "rubycritic/rake_task"

Rake::TestTask.new do |task|
  task.libs.push "lib"
  task.libs.push "test"
  task.pattern = "test/**/*_test.rb"
end

Reek::Rake::Task.new

RubyCritic::RakeTask.new do |task|
  task.paths = FileList["lib/**/*.rb"]
end

lint_tasks = []

begin
  require "rubocop/rake_task"
  RuboCop::RakeTask.new
  lint_tasks << :rubocop
rescue LoadError
  # RuboCop is not installed on the rubies the Gemfile skips the pin for.
end

task default: %i[test reek] + lint_tasks
