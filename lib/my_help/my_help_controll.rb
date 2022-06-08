# -*- coding: utf-8 -*-
require "fileutils"
require "yaml"
require_relative "./config"
require_relative "./my_help_list"

module MyHelp
  WrongFileName = Class.new(RuntimeError)

  class Error < StandardError
  end

  class Control
    include MyHelpList

    attr_accessor :local_help_dir, :editor

    def initialize(conf_path = nil)
      @conf_path = conf_path || ENV["HOME"]
      @conf = Config.new(@conf_path).config
      @local_help_dir = @conf[:local_help_dir]
      # for git command in ../my_help.rb, the method shoule be revise in this directory. (22/06/08)
      # puts YAML::dump(@conf)
      set_help_dir_if_not_exists
    end

    def set_editor(editor)
      @conf[:editor] = editor
      conf = { editor: editor }
      File.open(@conf[:conf_file], "w") { |f| YAML.dump(conf, f) }
      return "set editor '#{@conf[:editor]}'"
    end

    def set_help_dir_if_not_exists
      return if File::exist?(@conf[:local_help_dir])
      FileUtils.mkdir_p(@conf[:local_help_dir], :verbose => true)
      Dir.entries(@conf[:template_dir]).each { |file|
        next if file == "help_template.org"
        file_path = File.join(@conf[:local_help_dir], file)
        next if File::exists?(file_path)
        FileUtils.cp((File.join(@conf[:template_dir], file)), @conf[:local_help_dir], :verbose => true)
      }
    end

    def list_all
      output = "\nList all helps\n"
      local_help_entries.each do |file|
        file_path = File.join(@conf[:local_help_dir], file)
        title = file.split(".")[0]
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
      file_path = File.join(@conf[:local_help_dir], file + ".org")
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
      file_path = File.join(@conf[:local_help_dir], file + ".org")
      item_list(file_path, item)
    end

    def edit_help(file)
      p target_help = File.join(@conf[:local_help_dir], file + ".org")
      if local_help_entries.member?(file + ".org")
        system "#{@conf[:editor]} #{target_help}"
      else
        puts "file #{target_help} does not exits in #{@conf[:local_help_dir]}."
        puts "make #{file} first by 'new' command."
      end
    end

    def init_help(file = nil)
      target_help = File.join(@conf[:local_help_dir], file + ".org")
      if File::exist?(target_help)
        raise Error,
              "Warning: \'#{target_help}\' exists.  If sure, delete it first."
      end
      template = File.join(@conf[:template_dir], "help_template.org")
      FileUtils::Verbose.cp(template, target_help)
    end

    def delete_help(file)
      file = File.join(@conf[:local_help_dir], file + ".org")
      if File.exist?(file) == true
        print "Are you sure to delete " + file.blue + "?[Yn] ".red
        case STDIN.gets.chomp
        when "Y"
          begin
            FileUtils.rm(file, :verbose => true)
            return 0
          rescue => error
            puts error.to_s.red
            return 1
          end
        when "n", "q"; return 0
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

    def local_help_entries
      entries = []
      Dir.entries(@conf[:local_help_dir]).each { |file|
        next if file[0] == "#" or file[0] == "."
        if File.extname(file) == ".org" # OK?
          entries << file
        end
      }
      return entries
    end
  end
end
