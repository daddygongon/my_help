# -*- coding: utf-8 -*-
require 'fileutils'
require 'yaml'

module MyHelp
  class Control
    attr_accessor :local_help_dir, :editor
    def initialize()
      # for configuration setups
      # see https://stackoverflow.com/questions/6233124/where-to-place-access-config-file-in-gem

      @template_dir = File.expand_path("../../templates", __FILE__)
      @exe_dir = File.expand_path("../../exe", __FILE__)
      @local_help_dir = File.join(ENV['HOME'],'.my_help')
      @editor = 'code' #'emacs' #'vim' #default editor
      # @mini_account = File
      set_help_dir_if_not_exists
      load_conf
    end

    def set_editor(editor)
      @editor = editor
      file_name = '.my_help_conf.yml'
      @conf_file = File.join(@local_help_dir, file_name)
      conf = {editor: editor}
      File.open(@conf_file, 'w'){|f| YAML.dump(conf, f)}
      puts "set editor '#{@editor}'"
    end

    def load_conf
      file_name = '.my_help_conf.yml'
      # @conf_file = File.join(Dir.pwd, file_name)
      @conf_file = File.join(@local_help_dir, file_name)
      begin
        conf = YAML.load_file(@conf_file)
        @editor = conf[:editor]
      rescue => e
        puts e.to_s.red
        puts 'make .my_help_conf.yml'.green
        set_editor(@editor)
      end
    end

    def set_help_dir_if_not_exists
      return if File::exist?(@local_help_dir)
      FileUtils.mkdir_p(@local_help_dir, :verbose=>true)
      Dir.entries(@template_dir).each{|file|
        next if file=='help_template.org'
        file_path=File.join(@local_help_dir,file)
        next if File::exists?(file_path)
        FileUtils.cp((File.join(@template_dir,file)),@local_help_dir,:verbose=>true)
      }
    end

    def list_all
      output = "\nList all helps\n"
      local_help_entries.each do |file|
        file_path=File.join(@local_help_dir,file)
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

    WrongFileName = Class.new(RuntimeError)
    def list_help(file)
      output = ''
      file_path=File.join(@local_help_dir,file+'.org')
      begin
        help = auto_load(file_path)
      rescue => e
        raise WrongFileName, "No help named '#{file}' in the directory '#{local_help_dir}'."
      end
      help.each_pair do |key, conts|
        output << conts[:cont] if key==:head
        output << disp_opts( conts[:opts] )
      end
      output
    end

    WrongItemName = Class.new(RuntimeError)
    def show_item(file, item)
      output = ''
      file_path=File.join(@local_help_dir,file+'.org')
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
      p target_help = File.join(@local_help_dir,file+'.org')
      if local_help_entries.member?(file+'.org')
        system "#{@editor} #{target_help}"
      else
        puts "file #{target_help} does not exits in #{@local_help_dir}."
        puts "init #{file} first."
      end
    end

    def init_help(file)
      if file.nil?
        puts "specify NAME".red
        exit
      end
      p target_help=File.join(@local_help_dir,file+'.org')
      if File::exists?(target_help)
        puts "File exists. delete it first to initialize it."
        exit
      end
      p template = File.join(@template_dir,'help_template.org')
      FileUtils::Verbose.cp(template,target_help)
    end

=begin
       def delete_help(file)
         file = File.join(@local_help_dir,file+'.org')
         print "Are you sure to delete "+file.blue+"?[Ynq] ".red
         case STDIN.gets.chomp
         when 'Y'
           begin
             FileUtils.rm(file,:verbose=>true)
           rescue => error
             puts error.to_s.red
           end
         when 'n', 'q' ; exit
         end
       end
=end
     def delete_help(file)
       file = File.join(@local_help_dir,file+'.org')
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
       system "ls #{@local_help_dir} | grep #{find_char}"
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
         col_length = case col
                      when 0; output << item.rjust(5)+", "
                      when 1; output << item.ljust(15)+": "
                      else; output << item
                      end
         col += 1
       end
       output << "\n"
     end
     def local_help_entries
       entries= []
       Dir.entries(@local_help_dir).each{|file|
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

     def auto_load(file_path)
       case File.extname(file_path)
         #      when '.yml'
         #        cont = YAML.load(File.read(file_path))
       when '.org'
         cont = OrgToYaml.new(file_path).help_cont
       else
         puts "Not handling file types of #{file_path}"
         cont = nil
       end
       cont
     end
   end
 end
