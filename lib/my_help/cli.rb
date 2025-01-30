# coding: utf-8
require_relative 'translate'
require_relative 'count'
require 'fileutils'

module MyHelp
  class CLI < Thor
    include GetConfig
    class_option :help_dir, :type => :string

    class << self
      def exit_on_failure?
        true
      end
    end
    
    no_commands do
      def count_log
        @count_log ||= MyHelp::CountLog.new
      end

      def log_execution(command_name = nil)
        count_log.log_execution(command_name)
      end
    end
    
    map "-c" => :count
    desc "count [COMMAND]",MyHelp::Translations.translate(:count)
    subcommand "count",CountCLI
    
    package_name 'my_help'
    map "-v" => :version
    desc "version", MyHelp::Translations.translate(:version)

    def version
      log_execution("version")
      puts "my_help #{VERSION}"
    end

    desc "git [pull|push]", MyHelp::Translations.translate(:git)
    subcommand "git", Git

    map "-a" => :add_defaults
    desc "add_defaults", MyHelp::Translations.translate(:add_defaults)
    def add_defaults
      log_execution("add_defaults")
      puts "Adding defaults org files in .my_help"
      config = get_config
      help_dir = options["help_dir"] || config[:local_help_dir]
      current_orgs = Dir.glob(File.join(help_dir, "*.org")).map! { |f| File.basename(f) }
      new_orgs = Dir.glob(File.join(config[:template_dir], '*.org'))
      new_orgs.each do |new_org|
        unless current_orgs.include?(File.basename(new_org))
          FileUtils.cp(new_org, help_dir, verbose: true)
        end
      end
    end

    map "-i" => :init
    desc "init", MyHelp::Translations.translate(:init)

    def init(*args)
      log_execution("init")
      config = get_config
      init = Init.new(config)
      raise "Local help dir exist." if init.help_dir_exist?
      puts "Choose default markup '.org' [Y or .md]? "
      response = $stdin.gets.chomp
      config.configure(:ext => response) unless response.upcase[0] == "Y"
      init.mk_help_dir
      config.save_config
      init.cp_templates
      puts "If you want change editor use my_help set editor code."
    end

    desc "set [:key] [VAL]", MyHelp::Translations.translate(:set)

    def set(*args)
      log_execution("set")
      config = get_config
      key = args[0] || ""
      config.configure(key.to_sym => args[1])
      config.save_config
      conf_file_path = config[:conf_file]
      puts "conf_file_path: %s" % conf_file_path
      puts File.read(conf_file_path)
    end

    map "-l" => :list
    desc "list [HELP] [ITEM]", MyHelp::Translations.translate(:list)
    option :layer, :type => :numeric
    def list(*args)
      log_execution("list")
      config = get_config
      help_dir = options["help_dir"] || config[:local_help_dir]
      layer = options["layer"] || 1
      count_log = MyHelp::CountLog.new
      result = List.new(help_dir,
                    config[:ext],
                    layer).list(*args.join(" "))
      count_log.log_item_usage(help_dir, result)

      puts result
    end

    map "-e" => :edit
    desc "edit [HELP]", MyHelp::Translations.translate(:edit)
    def edit(*args)
      log_execution("edit")
      c = get_config
      help_name = args[0]
      help_file = File.join(c[:local_help_dir], help_name + c[:ext])
      Modify.new(c).edit(help_name)

      timestamp = Time.now.strftime("%Y-%m-%d %H:%M:%S %z")

      log_file = File.join(Dir.home, '.my_help', 'my_help_edit.log')
      File.open(log_file, 'a') do |file|
        file.puts("#{timestamp} - #{help_file}")
      end
    end

    desc "new  [HELP]", MyHelp::Translations.translate(:new)
    map "-n" => :new
    def new(*args)
      c = get_config
      help_name = args[0]
      help_file = File.join(c[:local_help_dir], help_name + c[:ext])
      Modify.new(c).new(help_file)
    end

    desc "place [TEMPLATE]", MyHelp::Translations.translate(:place)
    map "-p" => :place
    def place(*args)
      log_execution("place")
      config = get_config
      help_name = File.basename((args[0] || 'template.org'), '.org')
      t_file = File.join('.', help_name + ".org")
      if File.exist?(t_file)
        puts "File #{t_file} exists, set file_name."
      else
        FileUtils.cp(File.join(config[:template_dir],'template.org'),t_file,verbose:true)
      end
    end
    
    desc "delete [HELP]", MyHelp::Translations.translate(:delete)

    def delete(*args)
      log_execution("delete")
      c = get_config
      help_name = args[0]
      help_file = File.join(c[:local_help_dir], help_name + c[:ext])
      puts "Are you sure to delete #{help_file}? [YN]"
      responce = $stdin.gets.chomp
      if responce.upcase[0] == "Y"
        Modify.new(c).delete(help_file)
      else
        puts "Leave #{help_file} exists."
      end
    end

    desc "hello", MyHelp::Translations.translate(:hello)

    def hello
      log_execution("hello")
      name = $stdin.gets.chomp
      puts("Hello #{name}.")
    end

    desc "help [COMMAND]", MyHelp::Translations.translate(:help)
    def help(command = nil)
      log_execution("help")
      if command
        self.class.command_help(shell, command)
      else
        header = ENV['LANG']&.start_with?('ja') ? "使用可能なコマンド一覧：" : "my_help commands:" 
        shell.say header
        self.class.all_commands.each do |command_name, command|
          next if command.hidden?
          shell.say "  my_help #{command.usage.ljust(25)} # #{command.description}"
        end
      end
    end
  end
end
