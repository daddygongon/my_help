# coding: utf-8
require_relative 'translate'
require 'date'
require 'time'

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

    no_commands do
      def increment_execution_count
        count_file = File.join(Dir.home, '.my_help_count.txt') # カウントを保存するファイル
        log_file = File.join(Dir.home, '.my_help_log.txt') # 実行履歴を保存するファイル
        
        # 全体の実行カウントを更新
        current_count = File.exist?(count_file) ? File.read(count_file).to_i : 0
        File.write(count_file, current_count + 1)
        
        # 現在のタイムスタンプをログファイルに記録
        File.open(log_file, 'a') do |file|
          file.puts(Time.now.to_s)
        end
      end
      
      def count_past_week
        log_file = File.join(Dir.home, '.my_help_log.txt')
        return 0 unless File.exist?(log_file)
        
        # 1週間前の日付を計算
        one_week_ago = Time.now - (7 * 24 * 60 * 60)
        
        # ログファイルを読み込み、1週間以内のエントリをカウント
        File.readlines(log_file).map do |line|
          log_time = Time.parse(line.strip)
          log_time >= one_week_ago ? 1 : 0
        end.sum
      end
    end
    
    # 初期化時に実行カウントをインクリメント
    def initialize(*args)
      super
      increment_execution_count
    end
    
    map "-c" => :count
    desc "count", MyHelp::Translations.translate(:count)
    def count
      count_file = File.join(Dir.home, '.my_help_count.txt')
      current_count = File.exist?(count_file) ? File.read(count_file).to_i : 0
      
      # 過去1週間のカウントを取得
      past_week_count = count_past_week
      
      # メッセージをLANGに応じて切り替える
      if ENV['LANG'] && ENV['LANG'].start_with?('ja')
        puts "あなたは 'my_help' を #{current_count} 回実行しました。"
        puts "過去1週間では #{past_week_count} 回実行しました。"
      else
        puts "You have executed 'my_help' #{current_count} times."
        puts "In the past week, you executed it #{past_week_count} times."
      end
    end
    
    package_name 'my_help'
    map "-v" => :version
    desc "version", MyHelp::Translations.translate(:version)

    def version
      puts "my_help #{VERSION}"
    end

    desc "git [pull|push]", MyHelp::Translations.translate(:git)
    subcommand "git", Git

    map "-a" => :add_defaults
    desc "add_defaults", MyHelp::Translations.translate(:add_defaults)
    def add_defaults
      puts "Adding defaults org files in .my_help"
      config = get_config
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
    desc "init", MyHelp::Translations.translate(:init)

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

    desc "set [:key] [VAL]", MyHelp::Translations.translate(:set)

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
    desc "list [HELP] [ITEM]", MyHelp::Translations.translate(:list)
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
    desc "edit [HELP]", MyHelp::Translations.translate(:edit)
    def edit(*args)
      c = get_config
      help_name = args[0]
      Modify.new(c).edit(help_name)
    end

    desc "new  [HELP]", MyHelp::Translations.translate(:new)
    map "-n" => :new
    def new(*args)
      c = get_config
      help_name = args[0]
      help_file = File.join(c[:local_help_dir], help_name + c[:ext])
      Modify.new(c).new(help_file)
      #     puts res.stdout
    end

    desc "place [TEMPLATE]", MyHelp::Translations.translate(:place)
    map "-p" => :place
    def place(*args)
      config = get_config
      p help_name = File.basename( (args[0] || 'template.org'),
                                   '.org')
      t_file = File.join('.', help_name+".org")
      if File.exist?(t_file)
        puts "File #{t_file} exists, set file_name."
      else
        FileUtils.cp(File.join(config[:template_dir],'template.org'),
                     t_file, verbose: true)
      end
    end

    desc "delete [HELP]", MyHelp::Translations.translate(:delete)

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

    desc "hello", MyHelp::Translations.translate(:hello)

    def hello
      name = $stdin.gets.chomp
      puts("Hello #{name}.")
    end

    desc "help [COMMAND]", MyHelp::Translations.translate(:help)
    def help(command = nil)
      if command
        self.class.command_help(shell, command)
      else
        header = ENV['LANG'] == 'JP' ? "使用可能なコマンド一覧：" : "my_help commands:"
        shell.say header
        self.class.all_commands.each do |command_name, command|
          next if command.hidden?
          shell.say "  my_help #{command.usage.ljust(25)} # #{command.description}"
        end
      end
    end 
  end
end
