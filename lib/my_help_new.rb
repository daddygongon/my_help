# -*- coding: utf-8 -*-
require "optparse"
require "yaml"
require 'my_help/org2yml'
require 'my_help/yml2org'
require 'my_help/my_help_controll'
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
      @control = MyHelp::Control.new(argv)
    end

    def execute
      @argv << '--help' if @argv.size==0
      command_parser = OptionParser.new do |opt|
        opt.on('-v', '--version','show program Version.') { |v|
          opt.version = MyHelp::VERSION
          puts opt.ver
        }
        opt.on('-l', '--list [FILE]', 'list all helps or FILE'){|file| @control.list_helps(file)}
        opt.on('-i ITEM', '--item NAME', 'show NAME item'){|item| @item = item}
        opt.on('-s FILE', '--show FILE', 'show FILE'){|file| @control.show(file, @item)}
        opt.on('-e NAME', '--edit NAME', 'edit NAME help(eg test_help)'){|file| @control.edit_help(file) }
        opt.on('-m NAME', '--make NAME', 'make NAME help(eq test_help)'){|file| @control.init_help(file)}
        opt.on('-y', '--yml2org [FILE]', 'convert FILE from yaml to org format'){|file| yml2org(file)}
        opt.on('--delete NAME','delete NAME help'){|file| @control.delete_help(file)}
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
      delete_help(file)
    end
  end
end
