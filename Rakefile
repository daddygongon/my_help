# frozen_string_literal: true
require 'bundler/gem_tasks'
require 'rake/testtask'

Rake::TestTask.new(:test) do |t|
  t.options = '-v'
  t.libs << 'test'
  t.libs << 'lib'
  t.test_files = FileList['test/**/*_test.rb']
end

#task default: %i[test rubocop]
task :default do
  system "rake -T"
end

