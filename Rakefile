# -*- coding: utf-8 -*-
require "bundler/gem_tasks"
require "rspec/core/rake_task"
require 'fileutils'
require 'open3'

p base_path = File.expand_path('..', __FILE__)
p basename = File.basename(base_path)

task :default do
  system 'rake -T'
end

desc "open github origin url"
task :open_github do
  out, err, status = Open3.capture3("git remote -v")
  url = "https://"+ out.match(/^origin\s+git@(.+) \(fetch\)/)[1].gsub(':','/')
  system "open #{url}"
end


desc "cucumber with Japanese"
task :cucumber do
  Cucumber::Rake::Task.new do |t|
    t.cucumber_opts = %w{--format pretty -l ja}
  end
end

desc "rspec test for aruba"
task :rspec do
  RSpec::Core::RakeTask.new(:spec)
end

desc "auto re-install"
task :auto_reinstall do
  puts "[sudo] gem uninstall my_help"
  puts "cd my_help"
  puts "git remote add upstrem git@github.com:daddygongon/my_help.git"
  puts "git pull upstrem master"
  puts "rake clean_exe"
  puts "rake to_yml"
  puts "*cp lib/daddygongon/my_todo.yml ~/.my_help"
  puts "[sudo] bundle exec exe/my_help -m"
  puts "*source ~/.zshrc or source ~/.cshrc"
  puts "*my_help -l"
  puts "*rake add_yml"
  puts "*--editで編集画面を開けてみて，色が付いてなかったら，"
  puts "*mv ~/.emacs ~/.emacs.d/init.elを試してみる"
end

desc "add .yml mode on ~/.emacs.d/init.el"
task :add_yml do
  adds = <<EOS
;; =================
;;  .yml auto ruby-mode 
;; =================
(add-to-list 'auto-mode-alist '("\\.yml$" . ruby-mode))
EOS
  print adds
  p Dir.chdir(File.join(ENV['HOME'],'.emacs.d'))
  File.open('init.el','a+'){|file|
    cont=file.read
    cont.include?('.yml') ? break : file.write(adds)
  }
end

desc "add .yml on all help files"
task :to_yml do
  p Dir.chdir(File.join(ENV['HOME'],'.my_help'))
  Dir.entries('.').each{|file|
    next if file == '.' or file=='..'
    next if file[0]=='#' or file[-1]=='~'
    next unless File.extname(file)==''
    #FileUtils::DryRun.mv(file, file+'.yml',:verbose=>true)
    FileUtils.mv(file, file+'.yml',:verbose=>true)
  }
end

desc "clean up exe dir"
task :clean_exe do
  files = Dir.entries('exe')
  files.each{|file|
    next if ["my_help",".","..",".DS_Store",
             "emacs_help","e_h","my_todo"].include?(file)
    FileUtils.rm(File.join('./exe',file), :verbose=>true)
  }
end

