module MyHelp
  class CLI < Thor
    include GetConfig
    class_option :help_dir, :type => :string
    #    option :help_dir, :type => :string
    #    option :layer, :type => :numeric

    # THOR to SILENCE DEPRECATION
    # https://qiita.com/tbpgr/items/5edb1454634157ff816d
    class << self
      def exit_on_failure?
        true
      end
    end

    package_name 'my_help'
    map "-v" => :version
    map "--version" => :version

    desc "version", "show version"

    def version
      puts "my_help #{VERSION}"
    end

    desc "git [pull|push]", "git operations"
    subcommand "git", Git

    map "-a" => :add_defaults
    desc "add_defaults", "add defaults org files"
    def add_defaults
      puts "Adding defaults org files in .my_help"
      config = get_config
      if config[:template_dir] !=
         File.expand_path("../templates", __dir__)
        puts "inconsistency for :template_dir"
        config.configure(:template_dir=>
                         File.expand_path("../templates", __dir__))
        config.save_config
      end
      help_dir = options["help_dir"] || config[:local_help_dir]
      p current_orgs = Dir.glob(File.join(help_dir, "*.org")).
                         map!{|f| File.basename(f)}
      new_orgs = Dir.glob(File.join(config[:template_dir],'*.org'))
      new_orgs.each do |new_org|
        p [new_org, current_orgs.include?(File.basename(new_org))]
        unless current_orgs.include?(File.basename(new_org))
          FileUtils.cp(new_org, help_dir, verbose: true)
        end
      end
    end
    
    map "-i" => :init
    desc "init", "initialize my_help environment"

    def init(*args)
      config = get_config # for using methods in Config

      #config.ask_default
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

    desc "set [:key] [VAL]", "set editor or ext"

    def set(*args)
      config = get_config # for using methods in Config
      key = args[0] || ""
      config.configure(key.to_sym => args[1])
      config.save_config
      conf_file_path = config[:conf_file]
      puts "conf_file_path: %s" % conf_file_path
      puts File.read(conf_file_path)
    end

    map "-l" => :list
    desc "list [HELP] [ITEM]", "list helps"
    #    option :help_dir, :type => :string
    option :layer, :type => :numeric
    # use method_options [[https://github.com/rails/thor/wiki/Method-Options]]
    def list(*args)
      config = get_config
      help_dir = options["help_dir"] || config[:local_help_dir]
      layer = options["layer"] || 1
      puts List.new(help_dir,
                    config[:ext],
                    layer).list(*args.join(" "))
    end

    map "-e" => :edit
    desc "edit [HELP]", "edit help"
    def edit(*args)
      c = get_config
      help_name = args[0]
      Modify.new(c).edit(help_name)
    end

    desc "new  [HELP]", "mk new HELP"

    def new(*args)
      c = get_config
      help_name = args[0]
      help_file = File.join(c[:local_help_dir], help_name + c[:ext])
      Modify.new(c).new(help_file)
      #     puts res.stdout
    end

    desc "delete [HELP]", "delete HELP"

    def delete(*args)
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

    desc "hello", "hello"

    def hello
      name = $stdin.gets.chomp
      puts("Hello #{name}.")
    end

  end
end
