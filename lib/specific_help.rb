# -*- coding: utf-8 -*-
require "optparse"
require "yaml"
require "my_help/version"


module SpecificHelp
  class Command

    def self.run(file,argv=[])
      new(file, argv).execute
    end

    def initialize(file,argv=[])
      @help_cont = YAML.load(File.read(file))
      @help_cont[:head].each{|line| print line }
      @argv = argv
    end

    def execute
      @argv << '--help' if @argv.size==0
      command_parser = OptionParser.new do |opt|
        opt.on('-v', '--version','show program Version.') { |v|
          opt.version = MyHelp::VERSION
          puts opt.ver
        }
        @help_cont.each_pair{|key,val|
          next if key==:head
          opts = val[:opts]
          opt.on(opts[:short],opts[:long],opts[:desc]) {disp_from_help_cont(key)}
        }
        opt.on('--to_hiki','convert to hikidoc format'){to_hiki}
      end
#      begin
        command_parser.parse!(@argv)
#      rescue=> eval
#       p eval
#      end
      exit
    end

    def to_hiki
      puts '>>>'
      @help_cont.each_pair{|key,val|
        p key,val
#        opts = val[:opts]
#        puts opts[:short].to_s,opts[:long].to_s,opts[:desc].to_s
        items =@help_cont[key]
        puts items[:title]
        disp(items[:cont])
      }
    end

    def disp(lines)
      lines.each{|line|
        puts "  #{line}"
      }
    end

    def disp_from_help_cont(key_word)
      items =@help_cont[key_word]
      puts items[:title]
      disp(items[:cont])
    end
  end
end
