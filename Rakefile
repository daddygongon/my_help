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
  YARD::Rake::YardocTask.new {|t|
#    t.files=['**/*.md']
#    t.options=['-t','mathjax']
#    t.options=['--exclude','lib.rb','--files','**/*.org']
  }

end
