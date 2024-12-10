# coding: utf-8
require_relative 'translate'
require 'date'
require 'time'
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
      def log_dir
        File.join(Dir.home, '.my_help') # ログフォルダのパス
      end

      def log_file
        File.join(log_dir, 'my_help.log') # 日付別ログファイル
      end

      def command_log_file
        File.join(log_dir, 'my_help_command.log') # コマンド別ログファイル
      end

      def ensure_log_dir_exists
        FileUtils.mkdir_p(log_dir) unless Dir.exist?(log_dir)
      end

      def log_execution(command_name = nil)
        ensure_log_dir_exists
        return if command_name.nil? || command_name.empty?

        resolved_command = resolve_command_alias(command_name)

        return if ["count" , "-c"].include?(resolved_command)

        # コマンド別ログ更新
        command_counts = {}
        if File.exist?(command_log_file)
          File.readlines(command_log_file).each do |line|
            cmd, value = line.split(' ', 2)
            next if cmd.nil?
            command_counts[cmd] = value&.strip || ""
          end
        end

        command_counts[resolved_command] = "#{command_counts[resolved_command] || ''}*"

        File.open(command_log_file, 'w') do |file|
          command_counts.each { |cmd, stars| file.puts "#{cmd} #{stars}" }
        end

        # 日付別ログ更新
        today = Date.today.to_s
        date_counts = {}
        if File.exist?(log_file)
          File.readlines(log_file).each do |line|
            key, value = line.split
            next if key.nil? || value.nil? || key == "total"
            date_counts[key] = value.length
          end
        end

        date_counts[today] = (date_counts[today] || 0) + 1
        total_count = date_counts.values.sum

        File.open(log_file, 'w') do |file|
          date_counts.each { |date, count| file.puts "#{date} #{'*' * count}" }
          file.puts "total #{'*' * total_count}"
          file.puts "total #{total_count}回"
        end
      end

      def resolve_command_alias(command_name)
        command_aliases = {
          "-v" => "version",
          "-a" => "add_defaults",
          "-i" => "init",
          "-l" => "list",
          "-e" => "edit",
          "-n" => "new",
          "-p" => "place"
        }
        command_aliases[command_name] || command_name
      end

      def display_date_log(all: false)
        header = ENV['LANG']&.start_with?('ja') ? "=== 日付別実行回数 ===" : "=== Execution Count by Date ==="
        no_log_message = ENV['LANG']&.start_with?('ja') ? "ログはまだありません。" : "No logs available."
        unit = ENV['LANG']&.start_with?('ja') ? "回" : "times"
        total_label = ENV['LANG']&.start_with?('ja') ? "合計" : "total"

        if !all
          header += ENV['LANG']&.start_with?('ja') ? "(過去1週間分)" : "(Past Week)"
        end
        
        return "#{header} ===\n#{no_log_message}\n" unless File.exist?(log_file)
        
        counts = {}
        File.readlines(log_file).each do |line|
          key, value = line.split
          next if key.nil? || value.nil? || key == "total"
          counts[key] = value.length
        end

        total_count = counts.values.sum

        unless all
          one_week_ago = Date.today - 7
          counts.select! { |date, _| Date.parse(date) >= one_week_ago }
        end

        display = counts.map { |date, count| "#{date} #{count} #{unit}" }.join("\n")
        display += "\n#{total_label} #{total_count} #{unit}" if total_count > 0
        "#{header}\n#{display}\n"
      end

      def display_command_log
        header = ENV['LANG']&.start_with?('ja') ? "=== コマンド別実行回数 ===" : "=== Execution Count by Command ==="
        no_log_message = ENV['LANG']&.start_with?('ja') ? "ログはまだありません。" : "No logs available."
        unit = ENV['LANG']&.start_with?('ja') ? "回" : "times"
        
        return "#{header}\n#{no_log_message}\n" unless File.exist?(command_log_file)

        counts = {}
        File.readlines(command_log_file).each do |line|
          cmd, value = line.split(' ', 2)
          next if cmd.nil? || value.nil?
          counts[cmd] = value.strip.length
        end

        # 実行回数が1回以上のものだけを表示
        display = counts.reject { |_, count| count.zero? }
                        .map { |cmd, count| "#{cmd.ljust(15)} #{count}#{unit}" }
                        .join("\n")
        display.empty? ? "#{header}\n#{no_log_message}\n" : "#{header}\n#{display}\n"
      end

      def display_list_log
        log_file = File.join(Dir.home, '.my_help', 'my_help_list.log')
        header = ENV['LANG']&.start_with?('ja') ? "=== list使用履歴 ===" : "=== list Usage History ==="
        no_log_message = ENV['LANG']&.start_with?('ja') ? "ログはまだありません。" : "No logs available."
      
        return "#{header}\n#{no_log_message}\n" unless File.exist?(log_file)
      
        items = File.readlines(log_file).map { |line| line.strip }
        
        if items.empty?
          return "#{header}\n#{no_log_message}\n"
        end
        
        display = items.join("\n")
        "#{header}\n#{display}\n"
      end
      
      def log_item_usage(help_dir, result)
        log_file = File.join(Dir.home, '.my_help', 'my_help_list.log')
        # name と item が存在する場合のみログに記録
        if result.is_a?(String) && result.match(/my_help called with name : (\S+),item : (\S+)/)
          name = $1
          item = $2
          File.open(log_file, 'a') do |file|
            file.puts("#{Time.now} - #{help_dir}/#{name} called with name : #{name}, item : #{item}")
          end
        end
      end

      # my_help_edit.log の内容を表示するメソッド
      def display_edit_log
        header = ENV['LANG']&.start_with?('ja') ? "=== 編集されたファイル ===" : "=== Edited Files ==="
        no_log_message = ENV['LANG']&.start_with?('ja') ? "ログはまだありません。" : "No logs available."
        
        log_file = File.join(Dir.home, '.my_help', 'my_help_edit.log')
        return "#{header}\n#{no_log_message}\n" unless File.exist?(log_file)
        
        items = File.readlines(log_file).map { |line| line.strip }
        
        if items.empty?
          return "#{header}\n#{no_log_message}\n"
        end
        
        display = items.join("\n")
        "#{header}\n#{display}\n"
      end
    end
    
    def initialize(*args)
      super
      ensure_log_dir_exists
      log_execution(ARGV[0])
    end
    
    map "-c" => :count
    desc "count [COMMAND]",MyHelp::Translations.translate(:count)
    def count(option = nil)
      case option
      when "log"
        puts display_date_log(all: true)
      when "command"
        puts display_command_log
      when "list"
        puts display_list_log
      when "edit"
        puts display_edit_log
      else
        puts display_date_log
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
      config = get_config
      help_dir = options["help_dir"] || config[:local_help_dir]
      layer = options["layer"] || 1
      result = List.new(help_dir,
                    config[:ext],
                    layer).list(*args.join(" "))
      log_item_usage(help_dir, result)

      puts result
    end

    map "-e" => :edit
    desc "edit [HELP]", MyHelp::Translations.translate(:edit)
    def edit(*args)
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
