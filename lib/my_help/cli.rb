require "command_line/global"
require_relative "./git_cli"

module MyHelp
  class Error < StandardError; end

  # Your code goes here...
  class CLI < Thor

    # THOR to SILENCE DEPRECATION
    # https://qiita.com/tbpgr/items/5edb1454634157ff816d
    class << self
      def exit_on_failure?
        true
      end
    end

    desc "version", "show version"

    def version
      puts VERSION
    end

    desc "git [pull|push]", "git operations"
    subcommand "git", Git

    desc "init", "initialize my_help environment"

    def init(*args)
      config = get_config(args)
      #config.ask_default
      init = Init.new(config.config)
      raise "Local help dir exist." if init.check_dir_exist
      puts "Choose default markup '.org' [Y or .md]? "
      responce = $stdin.gets.chomp
      config.configure(:ext => responce) unless responce.upcase[0] == "Y"
      init.mk_help_dir
      config.save_config
      init.cp_templates
      puts "If you want change editor use my_help set editor code."
    end

    desc "set [:key] [VAL]", "set editor or ext"

    def set(*args)
      config = get_config(args)
      config.configure(args[0].to_sym => args[1])
      config.save_config
      conf_file_path = config.config[:conf_file]
      puts "conf_file_path: %s" % conf_file_path
      puts File.read(conf_file_path)
    end

    desc "list [HELP] [ITEM]", "list helps"
    option :help_dir, :type => :string
    option :layer, :type => :numeric
    # use method_options [[https://github.com/rails/thor/wiki/Method-Options]]
    def list(*args)
      config = get_config(args).config
      help_dir = options["help_dir"] || config[:local_help_dir]
      layer = options["layer"] || 1
      puts List.new(help_dir,
                    config[:ext],
                    layer).list(*args.join(" "))
    end

    desc "edit [HELP]", "edit help"

    def edit(*args)
      c = get_config(args).config
      help_name = args[0]
      Modify.new(c).edit(help_name)
    end

    desc "new  [HELP]", "mk new HELP"

    def new(*args)
      c = get_config(args).config
      help_name = args[0]
      help_file = File.join(c[:local_help_dir], help_name + c[:ext])
      Modify.new(c).new(help_file)
      #     puts res.stdout
    end

    desc "delete [HELP]", "delete HELP"

    def delete(*args)
      c = get_config(args).config
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

    desc "hello", "hello"

    def hello
      name = $stdin.gets.chomp
      puts("Hello #{name}.")
    end

    no_commands {
      def get_config(args)
        # RSpec環境と，実動環境の差をここで吸収
        # RSpecではargsの最後にtemp_dirをつけているから
        args[0] = "" if args.size == 0
        help_dir = args[-1]
        help_dir = ENV["HOME"] unless File.exist?(help_dir)
        return Config.new(help_dir)
      end
    }
  end
end
