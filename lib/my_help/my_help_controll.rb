# -*- coding: utf-8 -*-
require 'fileutils'
require 'yaml'
require_relative './config'
require_relative './my_help_list'

module MyHelp
  WrongFileName = Class.new(RuntimeError)

  class Control
    include MyHelpList
    
    attr_accessor :local_help_dir, :editor
    def initialize(conf_path=nil)
      @conf_path = conf_path || ENV['HOME']
      @conf = Config.new(@conf_path).config
      # puts YAML::dump(@conf)
      set_help_dir_if_not_exists
    end

    def set_editor(editor)
      @conf[:editor] = editor
      conf = {editor: editor}
      File.open(@conf[:conf_file], 'w'){|f| YAML.dump(conf, f)}
      puts "set editor '#{@conf[:editor]}'"
    end

    def set_help_dir_if_not_exists
      return if File::exist?(@conf[:local_help_dir])
      FileUtils.mkdir_p(@conf[:local_help_dir], :verbose=>true)
      Dir.entries(@conf[:template_dir]).each{|file|
        next if file=='help_template.org'
        file_path=File.join(@conf[:local_help_dir],file)
        next if File::exists?(file_path)
        FileUtils.cp((File.join(@conf[:template_dir],file)),@conf[:local_help_dir],:verbose=>true)
      }
    end

    def list_all
      output = "\nList all helps\n"
      local_help_entries.each do |file|
        file_path=File.join(@conf[:local_help_dir],file)
        title = file.split('.')[0]
        help = auto_load(file_path)
        next if help.nil?
        begin
          desc = help[:head][:cont].split("\n")[0]
        rescue => e
          puts e
          puts "No head in #{file_path}".red
          next
        end
        output << title.rjust(10)
        output << ": #{desc}\n"
      end
      output
    end

    def list_help(file)
      file_path=File.join(@conf[:local_help_dir],file+'.org')
      begin
        output = help_list(file_path)
      rescue
        raise WrongFileName,
        "No help named '#{file}' in '#{@conf[:local_help_dir]}'."
      end
      output
    end

    WrongItemName = Class.new(RuntimeError)
    def show_item(file, item)
      output = ''
      file_path=File.join(@conf[:local_help_dir],file+'.org')
      help = auto_load(file_path)
      select = select_item(help, item)
      output << help[:head][:cont]
      unless select then
        raise WrongItemName, "No item entry: #{item}"
      end
      output << '-'*5+"\n"+select.to_s.green+"\n"
      output << help[select][:cont]
    end

    def edit_help(file)
      p target_help = File.join(@conf[:local_help_dir],file+'.org')
      if local_help_entries.member?(file+'.org')
        system "#{@conf[:editor]} #{target_help}"
      else
        puts "file #{target_help} does not exits in #{@conf[:local_help_dir]}."
        puts "make #{file} first by 'new' command."
      end
    end

    def init_help(file)
      if file.nil?
        puts "specify NAME".red
        exit
      end
      p target_help=File.join(@conf[:local_help_dir],file+'.org')
      if File::exists?(target_help)
        puts "File exists. delete it first to initialize it."
        exit
      end
      p template = File.join(@conf[:template_dir],'help_template.org')
      FileUtils::Verbose.cp(template,target_help)
    end

    def delete_help(file)
      file = File.join(@conf[:local_help_dir],file+'.org')
      if File.exist?(file) == true
        print "Are you sure to delete "+file.blue+"?[Yn] ".red
        case STDIN.gets.chomp
        when 'Y'
          begin
            FileUtils.rm(file,:verbose=>true)
            return 0
          rescue => error
            puts error.to_s.red
            return 1
          end
        when 'n', 'q' ; return 0
        end
      else
        print file + " is a non-existent file"
      end
    end

    def search_help(word)
      p find_char = word
      system "ls #{@conf[:local_help_dir]} | grep #{find_char}"
    end

    private
    def select_item(help, item)
      o_key = nil
      help.each_pair do |key, cont|
        next if key==:license or key==:head
        if cont[:opts][:short] == item or cont[:opts][:long] == item
          o_key = key
          break
        end
      end
      o_key
    end

    def disp_opts( conts )
      output = ''
      col = 0
      conts.each_pair do |key, item|
        case col
        when 0 ; output << item.rjust(5)+", "
        when 1 ; output << item.ljust(15)+": "
        else   ; output << item
        end
        col += 1
      end
      output << "\n"
    end

    def local_help_entries
      entries= []
      Dir.entries(@conf[:local_help_dir]).each{|file|
        #        next unless file.include?('_')
        next if file[0]=='#' or file[-1]=='~' or file[0]=='.'
        #        next if file.match(/(.+)_e\.org/) # OK?
        #        next if file.match(/(.+)\.html/)
        if file.match(/(.+)\.org$/) # OK?
          entries << file
        end
      }
      return entries
    end

  end
end

