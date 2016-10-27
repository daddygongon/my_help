# -*- coding: utf-8 -*-
require "optparse"
require "yaml"
require "emacs_help/version"

module EmacsHelp
  class Command

    def self.run(argv=[])
      new(argv).execute
    end

    def initialize(argv=[])
      @help_cont = YAML.load(File.read('lib/daddygongon/emacs_help'))
      @help_cont[:head].each{|line| print line }
      @argv = argv
    end

    def execute
      @argv << '--help' if @argv.size==0
      command_parser = OptionParser.new do |opt|
        opt.on('-v', '--version','show program Version.') { |v|
          opt.version = EmacsHelp::VERSION
          puts opt.ver
        }
        @help_cont.each_pair{|key,val|
          next if key==:head
          opts = val[:opts]
          opt.on(opts[:short],opts[:long],opts[:desc]) {disp_from_help_cont(key)}
        }
      end
      begin
        command_parser.parse!(@argv)
      rescue=> eval
        p eval
      end
      exit
    end

    def disp(lines)
      lines.each{|line|
        if line.include?(',')
          puts "  #{line}"
        else
          puts "    #{line}"
        end
      }
    end

    def disp_from_help_cont(key_word)
      items =@help_cont[key_word]
      puts items[:title]
      disp(items[:cont])
    end
  end
end
