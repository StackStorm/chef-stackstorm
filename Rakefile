require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'foodcritic'

desc 'RuboCop compliancy checks'
RuboCop::RakeTask.new(:rubocop)

FoodCritic::Rake::LintTask.new do |t|
  t.options = {
    fail_tags: ['any']
  }
end

desc 'Run all linters on the codebase'
task :linters do
  Rake::Task['foodcritic'].invoke
  Rake::Task['rubocop'].invoke
end

RSpec::Core::RakeTask.new(:spec) do |t|
  t.fail_on_error = true
  t.pattern = 'spec/**/*_spec.rb'
end

task default: [:foodcritic, :rubocop, :spec]
