# -*- coding: utf-8 -*-
require "optparse"
require "yaml"
require "my_help/version"
require 'fileutils'
require "coderay"
require 'colorize'

module SpecificHelpOpt
  class Command
    def self.run(file,argv=[])
      new(file, argv).execute
    end

    def initialize(file,argv=[])
      @source_file = file
      @help_cont = YAML.load(File.read(file))
#      @help_cont[:head].each{|line| print line.chomp+"\n" } if @help_cont[:head] != nil
#      @help_cont[:license].each{|line| print "#{line.chomp}\n" } if @help_cont[:license] != nil
       @argv = argv
    end

    def execute
      if @argv.size==0
        if @source_file.include?('todo')
          @argv << '--all'
        else
          @argv << '--help'
        end
      end

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
      end
      begin
        command_parser.parse!(@argv)
      rescue=> eval
        p eval
      end

      end
    
    def disp_help(key_word)
      print_separater
      items =@help_cont[key_word]
      puts items[:title].magenta
      #      puts CodeRay.scan("-#{items[:title]}:", :Taskpaper).term
      disp(items[:cont])
      print_separater
    end
    
    def disp(lines)
        #      lines.each{|line| puts "  +#{line}"} if lines != nil
      lines.each{|line| puts "*#{line}".blue}
      #      lines.each{|line| puts CodeRay.scan("+#{line}", :Taskpaper).term}
    end
    
    def print_separater
        print "---\n"
    end
  end
end

