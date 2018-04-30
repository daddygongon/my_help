# -*- coding: utf-8 -*-
require "optparse"
require "yaml"
require "my_help/version"
require 'fileutils'
require "coderay"
require 'colorize'
require "thor"

module SpecificHelp
  class Command < Thor
#    def self.start(file,*args)
 #       new(file,*args).execute
  #  end
    def initialize(*args)
      super
#      p ENV['HELP_NAME']
      file=File.join(ENV['HOME'],'.my_help',"#{ENV['HELP_NAME']}.yml")
      puts "@initialize\n"

      @source_file = file
      @help_cont = YAML.load(File.read(@source_file))
      @help_cont[:head].each{|line| print line.chomp+"\n" } if @help_cont[:head] != nil
      @help_cont[:license].each{|line| print "#{line.chomp}\n" } if @help_cont[:license] != nil
      @argv = *args
    end

    desc 'backup NAME, --backup NAME','backup NAME help'
    map "--backup" => "backup"
    def backup(val)
      val = val || 10
      print "\n ...showing last #{val} stored items in backup.\n"
      backup=mk_backup_file(@source_file)
      File.open(backup,'r'){|file|
        backup_cont = YAML.load(File.read(backup))
        backup_size = backup_cont.size
        backup_size = backup_size>val.to_i ? val.to_i : backup_size
        backup_keys = backup_cont.keys
        backup_keys.reverse.each_with_index{|item,i|
          break if i>=backup_size
          line = item.to_s.split('_')
          printf("%10s : %8s%8s\n",line[0],line[1],line[2])
        }
      }
    end

    desc 'store NAME, --store','store NAME help'
    map "--store" => "store"
    def store(item)
      if item==nil
        print "spcify --store [item].\n"
        exit
      else
        print "Trying to store #{item}\n"
      end
      backup=mk_backup_file(@source_file)
      unless store_item = @help_cont[item.to_sym] then
        print "No #{item} in this help.  The items are following...\n"
        keys = @help_cont.keys
        keys.each{|key|
          p key
        }
        exit
      end
      p store_name = item+"_"+Time.now.strftime("%Y%m%d_%H%M%S")
      cont = {store_name.to_sym => store_item}
      backup_cont=YAML.load(File.read(backup)) || {}
      backup_cont[store_name.to_sym]=store_item
      File.open(backup,'w'){|file| file.print(YAML.dump(backup_cont))}
    end

    desc 'add NAME, --add NAME','add NAME help'
    map "--add" => "add"
    def add(item='new_item')
      print "Trying to add #{item}\n"
      new_item={:opts=>{:short=>'-'+item[0], :long=>'--'+item, :desc=>item},
          :title=>item, :cont=> [item]}
      @help_cont[item.to_sym]=new_item
      File.open(@source_file,'w'){|file| file.print YAML.dump(@help_cont)}
    end
    
    desc 'remove NAME, --remove NAME','remove NAME help'
    map "--remove" => "remove"
    def remove(item)
      print "Trying to remove #{item}\n"
      store(item)
      @help_cont.delete(item.to_sym)
      File.open(@source_file,'w'){|file| file.print YAML.dump(@help_cont)}
    end
    
    desc 'edit, --edit','edit help'
    map "--edit" => "edit"
    def edit
      puts "@edit\n"
      p help_file =@source_file
      begin
        p command= "emacs #{help_file}"
        exec command
      rescue => e
        print "\nOption edit is not executable on windows. \n"
        print "Type the following shell command;\n\n"
        print "emacs /home/#{ENV['USER']}/.my_help/#{File.basename(@source_file)}\n\n"
        print "M-x ruby-mode should be good for edit.\n"
      end
    end
    
    desc 'hiki, --hiki','hiki help'
    map "--hiki" => "hiki"
    def hiki
      @help_cont.each_pair{|key,val|
        if key==:head or key==:license
          hiki_disp(val)
        else
          hiki_help(key)
        end
      }
    end

    desc 'all, --all','all help'
    map "--all" => "all"
    def all
      @help_cont.each_pair{|key,val|
        if key==:head or key==:license
          val[0]+=":"
          disp(val)
        else
          disp_help(key)
        end
      }
    end

    no_commands do

      def mk_backup_file(file)
        path = File.dirname(file)
        base = File.basename(file)
        backup= File.join(path,"."+base)
        FileUtils.touch(backup) unless File.exists?(backup)
        return backup
      end

      def hiki_help(key_word)
        items =@help_cont[key_word]
        puts "\n!!"+items[:title]+"\n"
        hiki_disp(items[:cont])
      end

      def hiki_disp(lines)
        lines.each{|line| puts "*#{line}"}  if lines != nil
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
end
