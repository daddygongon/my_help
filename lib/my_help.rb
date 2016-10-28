# -*- coding: utf-8 -*-
require "optparse"
require "yaml"
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
      p @target_dir = File.expand_path("../../lib/daddygongon", __FILE__)
    end

    def execute
      @argv << '--help' if @argv.size==0
      command_parser = OptionParser.new do |opt|
        opt.on('-v', '--version','show program Version.') { |v|
          opt.version = MyHelp::VERSION
          puts opt.ver
        }
        opt.on('-l', '--list', 'list specific helps.'){list_helps}
        opt.on('-e NAME', '--edit NAME', 'edit NAME help.'){|file| edit_help(file)}
        opt.on('-i NAME', '--init NAME', 'initialize NAME help.'){}
        opt.on('-m', '--make', 'make and install:local all helps.'){}
      end
      begin
        command_parser.parse!(@argv)
      rescue=> eval
        p eval
      end
      exit
    end

    def edit_help(file)
      p File.join(@target,file)
    end

    def list_helps
      print "Specific help file:\n"
      Dir.entries(@target_dir)[2..-1].each{|file|
        print "  "+file+"\n"
      }
    end
  end
end
