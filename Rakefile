require "bundler/gem_tasks"
require "rake/testtask"
require 'yard'

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/**/*_test.rb"]
end

task :default => :test

desc "make documents by yard"
task :yard do
  api_output_dir = 'public'
  YARD::Rake::YardocTask.new {|t|
    t.options << "-o#{api_output_dir}" # output dir = doc_api
    # t.files=['**/*.md']
    t.options += ['--title','my_help']
    # t.options=['--exclude','lib.rb','--files','**/*.org']
    # see [[https://github.com/lsegal/yard/issues/66]] for the other options
  }

end
