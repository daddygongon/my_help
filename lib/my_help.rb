# -*- coding: utf-8 -*-
require "optparse"
require "yaml"
require "fileutils"
#require "emacs_help/version"
require "my_help/version"
#require "emacs_help"

module MyHelp
  class Command

    def self.run(argv=[])
      new(argv).execute
    end

    def initialize(argv=[])
      @argv = argv
      @target_dir = File.expand_path("../../lib/daddygongon", __FILE__)
    end

    def execute
      @argv << '--help' if @argv.size==0
      command_parser = OptionParser.new do |opt|
        opt.on('-v', '--version','show program Version.') { |v|
          opt.version = MyHelp::VERSION
          puts opt.ver
        }
        opt.on('-l', '--list', '個別(specific)ヘルプのList表示.'){list_helps}
        opt.on('-e NAME', '--edit NAME', 'NAME(例：test_help)をEdit編集.'){|file| edit_help(file)}
        opt.on('-i NAME', '--init NAME', 'NAME(例：test_help)のtemplateを作成.'){|file| init_help(file)}
        opt.on('-m', '--make', 'make and install:local all helps.'){make_help}
        opt.on('-c', '--clean', 'clean up exe dir.'){clean_exe}
      end
      begin
        command_parser.parse!(@argv)
      rescue=> eval
        p eval
      end
      exit
    end

    def short_name(file)
      file_name=file.split('_')
      return file_name[0][0]+"_"+file_name[1][0]
    end

    def make_help
      Dir.entries(@target_dir)[2..-1].each{|file|
        next if file[0]=='#' or file[-1]=='~'
        exe_cont="#!/usr/bin/env ruby\nrequire 'specific_help'\n"
#        exe_cont << "help_file = '#{File.join(@target_dir,file)}'\n"
#        exe_cont << @target_dir
        exe_cont << 'target_dir = File.expand_path("../../lib/daddygongon", __FILE__)'+"\n"
        exe_cont << "help_file = File.join(target_dir,'#{file}')\n"
        exe_cont << "SpecificHelp::Command.run(help_file, ARGV)\n"
        [file, short_name(file)].each{|name|
          p target=File.join('exe',name)
          File.open(target,'w'){|file| file.print exe_cont}
          FileUtils.chmod('a+x', target, :verbose => true)
        }
      }
    end

    def clean_exe
      Dir.entries(@target_dir)[2..-1].each{|file|
        next if file[0]=='#' or file[-1]=='~'
        [file, short_name(file)].each{|name|
          p target=File.join('exe',name)
          FileUtils::Verbose.rm(target)
        }
      }
    end

    def init_help(file)
      p target_help=File.join(@target_dir,file)
      p template = File.join(File.dirname(@target_dir),'my_help','template_help')
      FileUtils::Verbose.cp(template,target_help)
    end

    def edit_help(file)
      p target_help=File.join(@target_dir,file)
      system "emacs #{target_help}"
    end

    def list_helps
      print "Specific help file:\n"
      Dir.entries(@target_dir)[2..-1].each{|file|
        print "  "+file+"\n"
      }
    end
  end
end
