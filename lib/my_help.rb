# -*- coding: utf-8 -*-
require "optparse"
require "yaml"
require "fileutils"
require "my_help/version"
require "systemu"

module MyHelp
  class Command

    def self.run(argv=[])
      new(argv).execute
    end

    def initialize(argv=[])
      @argv = argv
      @default_help_dir = File.expand_path("../../lib/daddygongon", __FILE__)
      @local_help_dir = File.join(ENV['HOME'],'.my_help')
      set_help_dir_if_not_exists
    end

    def set_help_dir_if_not_exists
      return if File::exists?(@local_help_dir)
      FileUtils.mkdir_p(@local_help_dir, :verbose=>true)
      Dir.entries(@default_help_dir).each{|file|
        next if file=='template_help.yml'
        file_path=File.join(@local_help_dir,file)
        next if File::exists?(file_path)
        FileUtils.cp((File.join(@default_help_dir,file)),@local_help_dir,:verbose=>true)
      }
    end

    def execute
      @argv << '--help' if @argv.size==0
      command_parser = OptionParser.new do |opt|
        opt.on('-v', '--version','show program Version.') { |v|
          opt.version = MyHelp::VERSION
          puts opt.ver
        }
        opt.on('-l', '--list', 'list specific helps'){list_helps}
        opt.on('-e NAME', '--edit NAME', 'edit NAME help(eg test_help)'){|file| edit_help(file)}
        opt.on('-i NAME', '--init NAME', 'initialize NAME help(eg test_help).'){|file| init_help(file)}
        opt.on('-m', '--make', 'make executables for all helps.'){make_help}
        opt.on('-c', '--clean', 'clean up exe dir.'){clean_exe}
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

    def delete_help(file)
      del_files=[]
      del_files << File.join(@local_help_dir,file)
       exe_dir=File.join(File.expand_path('../..',@default_help_dir),'exe')
       del_files << File.join(exe_dir,file)
      p del_files << File.join(exe_dir,short_name(file))
      print "Are you sure to delete these files?[yes]"
      if gets.chomp=='yes' then
        del_files.each{|file| FileUtils.rm(file,:verbose=>true)}
      end
    end

    USER_INST_DIR="USER INSTALLATION DIRECTORY:"
    INST_DIR="INSTALLATION DIRECTORY:"
    def install_local
      Dir.chdir(File.expand_path('../..',@default_help_dir))
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
        exe_cont="#!/usr/bin/env ruby\nrequire 'specific_help'\n"
        exe_cont << "help_file = File.join(ENV['HOME'],'.my_help','#{file}')\n"
        exe_cont << "SpecificHelp::Command.run(help_file, ARGV)\n"
        file = File.basename(file,'.yml')
        [file, short_name(file)].each{|name|
          p target=File.join('exe',name)
          File.open(target,'w'){|file| file.print exe_cont}
          FileUtils.chmod('a+x', target, :verbose => true)
        }
      }
      install_local
    end

    def clean_exe
      local_help_entries.each{|file|
        next if ['emacs_help','e_h','my_help','todo_help'].include?(file)
        file = File.basename(file,'.yml')
        [file, short_name(file)].each{|name|
          p target=File.join('exe',name)
          FileUtils::Verbose.rm(target)
        }
      }
    end

    def init_help(file)
      p target_help=File.join(@local_help_dir,file+'.yml')
      if File::exists?(target_help)
        puts "File exists. rm it first to initialize it."
        exit
      end
      p template = File.join(@default_help_dir,'template_help.yml')
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
        entries << file
      }
      return entries
    end

    def list_helps
      print "Specific help file:\n"
      local_help_entries.each{|file|
        file_path=File.join(@local_help_dir,file)
        file = File.basename(file,'.yml')
        begin
          help = YAML.load(File.read(file_path))
        rescue=> eval
          p eval
          print "\n YAML load error in #{file}."
          print "  See the line shown above and revise by\n"
          print "  emacs #{file_path}\n"
          exit
        end
        print "  #{file}\t:#{help[:head][0]}\n"
      }
    end
  end
end
