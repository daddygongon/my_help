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
      @source_file = file
      @help_cont = YAML.load(File.read(file))
      @help_cont[:head].each{|line| print line.chomp+"\n" }
      @help_cont[:license].each{|line| print "#{line.chomp}\n" } if @help_cont[:license] != nil
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
          next if key==:head or key==:license
          opts = val[:opts]
          opt.on(opts[:short],opts[:long],opts[:desc]) {disp_help(key)}
        }
        opt.on('--edit','edit help contents'){edit_help}
        opt.on('--to_hiki','convert to hikidoc format'){to_hiki}
        opt.on('--all','display all helps'){all_help}
      end
#      begin
      command_parser.parse!(@argv)
#      rescue=> eval
#       p eval
#      end
      exit
    end

    def edit_help
      system("emacs #{@source_file}")
    end

    def to_hiki
      @help_cont.each_pair{|key,val|
        if key==:head or key==:license
          hiki_disp(val)
        else
          hiki_help(key)
        end
      }
    end

    def all_help
      @help_cont.each_pair{|key,val|
        if key==:head or key==:license
          disp(val)
        else
          disp_help(key)
        end
      }
    end

    def hiki_help(key_word)
      items =@help_cont[key_word]
      puts "\n!!"+items[:title]+"\n"
      hiki_disp(items[:cont])
    end

    def hiki_disp(lines)
      lines.each{|line| puts "*#{line}"}
    end

    def disp_help(key_word)
      print_separater
      items =@help_cont[key_word]
      puts items[:title]
      disp(items[:cont])
      print_separater
    end

    def disp(lines)
      lines.each{|line| puts "  *#{line}"}
    end

    def print_separater
      print "---\n"
    end
  end
end
