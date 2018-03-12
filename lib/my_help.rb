# -*- coding: utf-8 -*-
require "optparse"
require "yaml"
require 'my_help/org2yml'
require 'my_help/yml2org'
require "fileutils"
require "my_help/version"
require "systemu"
require "colorize"

module MyHelp
  class Command

    def self.run(argv=[])
      new(argv).execute
    end

    def initialize(argv=[])
      @argv = argv
      @template_dir = File.expand_path("../../lib/templates", __FILE__)
      @local_help_dir = File.join(ENV['HOME'],'.my_help')
      set_help_dir_if_not_exists
    end

    def set_help_dir_if_not_exists
      return if File::exists?(@local_help_dir)
      FileUtils.mkdir_p(@local_help_dir, :verbose=>true)
      Dir.entries(@template_dir).each{|file|
        next if file=='template_help.yml'
        file_path=File.join(@local_help_dir,file)
        next if File::exists?(file_path)
        FileUtils.cp((File.join(@template_dir,file)),@local_help_dir,:verbose=>true)
      }
    end

    def execute
      @argv << '--help' if @argv.size==0
      command_parser = OptionParser.new do |opt|
        opt.on('-v', '--version','show program Version.') { |v|
          opt.version = MyHelp::VERSION
          puts opt.ver
        }
        if ENV['LANG'] == "C" then
          opt.on('-l', '--list', 'list specific helps'){list_helps}
          opt.on('-e NAME', '--edit NAME', 'edit NAME help(eg test_help)'){|file| edit_help(file)}
          opt.on('-i NAME', '--init NAME', 'initialize NAME help(eq test_help)'){|file| init_help(file)}
        else
          opt.on('-l', '--list', '個別(specific)ヘルプのList表示.'){list_helps}
          opt.on('-e NAME', '--edit NAME', 'NAME(例：test_help)をEdit編集.'){|file| edit_help(file)}
          opt.on('-i NAME', '--init NAME', 'NAME(例：test_help)のtemplateを作成.'){|file| init_help(file)}
        end
        opt.on('-m', '--make', 'make executables for all helps'){make_help}
        opt.on('-c', '--clean', 'clean up exe dir.'){clean_exe_dir}
        opt.on('-y', '--yml2org [FILE]', 'convert FILE from yaml to org format'){|file| yml2org(file)}
        opt.on('--install_local','install local after edit helps'){install_local}
        opt.on('--delete NAME','delete NAME help'){|file| delete_help(file)}
      end
      begin
        command_parser.parse!(@argv)
      rescue=> eval
        p eval
      end
      exit
    end

    def yml2org(file)
      p target = File.join(@local_help_dir,file+'.yml')
      cont = YmlToOrg.new(target).contents
      dump = file+'.org'
      File.open(dump, 'w'){|file| file.print cont }
      print "May I delete #{target}? [Yn] ".red
      FileUtils.rm(target, verbose: true) if gets.chomp == 'Y'
    end

    def delete_help(file)
      del_files=[]
      del_files << File.join(@local_help_dir,file+'.yml')
      exe_dir=File.join(File.expand_path('../..',@template_dir),'exe')
      exe_0_dir='/usr/local/bin'
      del_files << File.join(exe_dir,file)
      del_files << File.join(exe_0_dir,file)
      del_files << File.join(exe_dir,short_name(file))
      del_files << File.join(exe_0_dir,short_name(file))
      del_files.each{|file|
        print "Are you sure to delete "+file.blue+"?[Ynq] ".red
        case gets.chomp
        when 'Y'
          begin
            FileUtils.rm(file,:verbose=>true)
          rescue => error
            puts error.to_s.red
          end
        when 'n' ; next
        when 'q' ; exit
        end
      }
    end

    USER_INST_DIR="USER INSTALLATION DIRECTORY:"
    INST_DIR="INSTALLATION DIRECTORY:"
    def install_local
      Dir.chdir(File.expand_path('../..',@template_dir))
      p pwd_dir = Dir.pwd
      # check that the working dir should not the gem installed dir,
      # which destroys itself.
      status, stdout, stderr = systemu "gem env|grep '#{USER_INST_DIR}'"
      if stdout==""
        status, stdout, stderr = systemu "gem env|grep '#{INST_DIR}'"
      end
      p system_inst_dir = stdout.split(': ')[1].chomp
      if pwd_dir == system_inst_dir
        puts "Download my_help from github, and using bundle for edit helps\n"
        puts "Read README in detail.\n"
        exit
      end
      system "git add -A"
      system "git commit -m 'update exe dirs'"
      system "Rake install:local"
    end

    def short_name(file)
      file_name=file.split('_')
      return file_name[0][0]+"_"+file_name[1][0]
    end

    def make_help
      local_help_entries.each{|file|
        title = file.split('.')[0]
        exe_cont=<<"EOS"
#!/usr/bin/env ruby
require 'specific_help'
if ENV['LANG'] == "C" then
  help_file = File.join(ENV['HOME'],'.my_help','#{file}_e.yml')
else
  help_file = File.join(ENV['HOME'],'.my_help','#{file}')
end
SpecificHelp::Command.run(help_file, ARGV)
EOS
        [title, short_name(title)].each{|name|
          p target=File.join('exe',name)
          File.open(target,'w'){|file| file.print exe_cont}
          FileUtils.chmod('a+x', target, :verbose => true)
        }
      }
      install_local
    end

    def clean_exe_dir
      local_help_entries.each{|file|
        next if ['emacs_help','e_h','my_help','my_todo'].include?(file)
        file = File.basename(file,'.yml')
        [file, short_name(file)].each{|name|
          p target=File.join('exe',name)
        begin
          FileUtils::Verbose.rm(target)
        rescue=> eval
          puts eval.to_s.red
        end
        }
      }
    end

    def init_help(file)
      p target_help=File.join(@local_help_dir,file+'.yml')
      if File::exists?(target_help)
        puts "File exists. rm it first to initialize it."
        exit
      end
      p template = File.join(@template_dir,'template_help.yml')
      FileUtils::Verbose.cp(template,target_help)
    end

    def edit_help(file)
      p target_help=File.join(@local_help_dir,file)
      system "emacs #{target_help}.yml"
    end

    def local_help_entries
      entries= []
      Dir.entries(@local_help_dir).each{|file|
        next unless file.include?('_')
        next if file[0]=='#' or file[-1]=='~' or file[0]=='.'
        next if file.match(/(.+)_e\.yml/) # OK?
        entries << file
      }
      return entries
    end

    def auto_load(file_path)
      case File.extname(file_path)
      when '.yml'
        cont = YAML.load(File.read(file_path))
      when '.org'
        cont = OrgToYaml.new(file_path).help_cont
      else
        puts "Not handling file types of #{file}"
      end
      cont
    end

    def list_helps
      print "Specific help file:\n"
      local_help_entries.each{|file|
        file_path=File.join(@local_help_dir,file)
        title = file.split('.')[0]
        begin
          help = auto_load(file_path)
        rescue=> eval
          p eval.to_s.red
          print "\n YAML load error in #{file}.".red
          print "  Revise it by "+"my_help --edit #{title}\n".red
          exit
        end
        print "  #{title}\t: #{help[:head][0]}\n".blue
      }
    end
  end
end
