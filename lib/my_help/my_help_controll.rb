# -*- coding: utf-8 -*-
module MyHelp
  class Control
    def initialize()
      # for configuration setups
      # see https://stackoverflow.com/questions/6233124/where-to-place-access-config-file-in-gem

      @template_dir = File.expand_path("../../templates", __FILE__)
      @exe_dir = File.expand_path("../../exe", __FILE__)
      @local_help_dir = File.join(ENV['HOME'],'.my_help')
      @editor = 'emacs'
     # @mini_account = File
      set_help_dir_if_not_exists
    end

    def set_help_dir_if_not_exists
      return if File::exists?(@local_help_dir)
      FileUtils.mkdir_p(@local_help_dir, :verbose=>true)
      Dir.entries(@template_dir).each{|file|
        next if file=='help_template.org'
        file_path=File.join(@local_help_dir,file)
        next if File::exists?(file_path)
        FileUtils.cp((File.join(@template_dir,file)),@local_help_dir,:verbose=>true)
      }
    end

    def show_item(file, item)
      file_path=File.join(@local_help_dir,file+'.org')
      help = auto_load(file_path)
      select = select_item(help, item)
      print help[:head][:cont]
      unless select then print "No entry: #{item}".red ; exit end
      puts '-'*5+"\n"+select.to_s.green
      print help[select][:cont]
    end

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

    def list_help(file)
      file_path=File.join(@local_help_dir,file+'.org')
      help = auto_load(file_path)
      help.each_pair do |key, conts|
        print conts[:cont] if key==:head
        disp_opts( conts[:opts] )
      end
    end

    def disp_opts( conts )
      col = 0
      conts.each_pair do |key, item|
        col_length = case col
                     when 0; print item.rjust(5)+", "
                     when 1; print item.ljust(15)+": "
                     else; print item
                     end
        col += 1
      end
      print("\n")
    end

    def list_all
      print "List all helps\n"
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
        print title.rjust(10).blue
        print ": #{desc}\n".blue
      end
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

    def upload_help(file)
      p target_help = File.join(@local_help_dir,file+'.org')
      puts "miniのuser_nameを入力してください．"
      p user_name = STDIN.gets.chomp
      puts "保存するディレクトリ名を入力してください．"
      p directory_name = STDIN.gets.chomp
      if local_help_entries.member?(file+'.org')
        #        if target_help.empty?(file+'.org')
#          system "scp #{@local_help_dir} tomoko_y@mini:~/our_help/member/tomoko"
#        else
        system "scp #{target_help} #{user_name}@mini:~/our_help/member/#{directory_name}"
      puts "後は，miniでgitにpushしてください．"
#      end
      else
        puts "file #{target_help} does not exits in #{@local_help_dir}."
        puts "init #{file} first."
      end
    end

=begin
    def search_help(file)
      p find_char = STDIN.gets.chomp
      system "ls #{@local_help_dir} | grep #{find_char}"
    end
=end

    private
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
