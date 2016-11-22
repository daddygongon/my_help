require "bundler/gem_tasks"
require 'yard'
require "rake/testtask"
require 'fileutils'
p base_path = File.expand_path('..', __FILE__)
p basename = File.basename(base_path)

task :default do
  system 'rake -T'
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

desc "make documents by yard"
task :yard => [:hiki2md] do
  YARD::Rake::YardocTask.new
end

desc "clean up exe dir"
task :clean_exe do
  files = Dir.entries('exe')
  files.each{|file|
    next if ["my_help",".","..",".DS_Store",
             "emacs_help","e_h","todo_help"].include?(file)
    FileUtils.rm(File.join('./exe',file), :verbose=>true)
  }
end

desc "transfer hikis/*.hiki to wiki"
task :hiki2md do
  files = Dir.entries('hikis')
  files.each{|file|
    name=file.split('.')
    case name[1]
    when 'hiki'
      p command="hiki2md hikis/#{name[0]}.hiki > #{basename}.wiki/#{name[0]}.md"
      system command
    when 'gif','png','pdf'
      p command="cp hikis/#{file} #{basename}.wiki/#{file}"
#      system command
      FileUtils.cp("hikis/#{file}","#{basename}.wiki/#{file}",:verbose=>true)
      FileUtils.cp("hikis/#{file}","doc/#{file}",:verbose=>true)
    end
  }
  readme_en="#{basename}.wiki/README_en.md"
  readme_ja="#{basename}.wiki/README_ja.md"
  FileUtils.cp(readme_en,"./README_en.md",:verbose=>true)
  FileUtils.cp(readme_ja,"./README.md",:verbose=>true)
  FileUtils.cp(readme_ja,"#{basename}.wiki/Home.md",:verbose=>true)
end

desc "transfer hikis/*.hiki to latex"
task :latex do
  target = 'handout_sample'
  command = "hiki2latex --pre latexes/handout_pre.tex hikis/#{target}.hiki > latexes/#{target}.tex"
  system command
  command = "open latexes/#{target}.tex"
  system command
end


