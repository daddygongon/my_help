# frozen_string_literal: true
require 'yard'
require 'bundler/gem_tasks'
require 'rake/testtask'

Rake::TestTask.new(:test) do |t|
  t.options = '-v'
  t.libs << 'test'
  t.libs << 'lib'
  t.test_files = FileList['test/**/*_test.rb']
end

desc 'make documents by yard'
task :yard do
  # api_output_dir = 'doc'
  YARD::Rake::YardocTask.new do |t|
    # t.options << '-o#{api_output_dir}' # output dir = doc_api
    # t.files=['**/*.md']
    t.options += ['--title', 'my_help']
    # t.options=['--exclude','lib.rb','--files','**/*.org']
    # see [[https://github.com/lsegal/yard/issues/66]] for the other options
  end
end

require 'rubocop/rake_task'

RuboCop::RakeTask.new

#task default: %i[test rubocop]
task :default do
  system "rake -T"
end

require "colorize"
require 'command_line/global'

desc 'git auto'
task :git_auto do
  print "Input comments: "
  comment = STDIN.gets.chomp 
  comment = comment == "" ? "auto pull and push" : comment.gsub("\'", "\\'")
  ["git add -A",
   "git commit -m '#{comment}'",
   "git pull origin main",
   "git push origin main"].each do |comm|
    puts comm.cyan
    res = command_line comm
    puts res.stdout.green
  end
end

