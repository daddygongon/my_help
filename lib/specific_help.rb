# -*- coding: utf-8 -*-
require "optparse"
require "yaml"
require "my_help/version"
require 'fileutils'
require 'colorize'
require 'my_help/org2yml'
require 'my_help/yml2org'

module SpecificHelp
  class Command

    def self.run(file,argv=[])
      new(file, argv).execute
    end

    def initialize(file,argv=[])
      @source_file = file
      @help_cont = OrgToYaml.new(file).help_cont
      [:head,:license].each do |sym|
        target = @help_cont[sym]
        print target[:cont] if target != nil
      end
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
        opt.on('--edit','edit help contents'){edit_help}
        opt.on('--all','display all helps'){all_help}
        opt.on('--store [item]','store [item] in backfile'){|item| store(item)}
        opt.on('--remove [item]','remove [item] and store in backfile'){|item| remove(item) }
        opt.on('--add [item]','add new [item]'){|item| add(item) }
        opt.on('--backup_list [val]','show last [val] backup list'){|val| backup_list(val)}
      end
      begin
        command_parser.parse!(@argv)
      rescue=> eval
        p eval
      end
      exit
    end

    def backup_list(val)
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

    def mk_backup_file(file)
      path = File.dirname(file)
      base = File.basename(file)
      backup= File.join(path,"."+base)
      FileUtils.touch(backup) unless File.exists?(backup)
      return backup
    end

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

    def add(item='new_item')
      print "Trying to add #{item}\n"
      new_item={:opts=>{:short=>'-'+item[0], :long=>'--'+item, :desc=>item},
          :title=>item, :cont=> [item]}
      @help_cont[item.to_sym]=new_item
      File.open(@source_file,'w'){|file| file.print YmlToOrg::yml_to_org(@help_cont)}
    end

    def remove(item)
      print "Trying to remove #{item}\n"
      store(item)
      @help_cont.delete(item.to_sym)
      File.open(@source_file,'w'){|file| file.print YAML.dump(@help_cont)}
    end

    def edit_help
       help_file =@source_file
      begin
        p command= "emacs #{help_file}"
        exec command
      rescue => e
        print "\nOption edit is not executable on windows. \n"
        print "Type the following shell command;\n\n"
        print "emacs /home/#{ENV['USER']}/.my_help/#{File.basename(@source_file)}\n\n"
      end
    end

    def all_help
      @help_cont.each_pair{|key,val|
        if key==:head or key==:license
          if val.kind_of?(Hash)
            disp(val[:cont][0]+=":")
          else
            val[0]+=":"
            disp(val)
          end
        else
          disp_help(key)
        end
      }
    end

    def disp_help(key_word)
      print_separater
      items =@help_cont[key_word]
      puts items[:title].magenta
      disp(items[:cont])
      print_separater
    end

    def disp(lines)
      if lines.kind_of?(Array)
        lines.each{|line| puts "* #{line}".blue}
      else
        print lines
      end
    end

    def print_separater
      print "---\n"
    end

  end
end
