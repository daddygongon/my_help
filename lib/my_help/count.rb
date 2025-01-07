# coding: utf-8
# count.rb
# coding: utf-8
require 'date'
require 'time'
require 'fileutils'

module MyHelp  
  class CountLog
    def initialize
      ensure_log_dir_exists
    end

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
      return if command_name.nil? || command_name.empty?

      resolved_command = resolve_command_alias(command_name)
      return if ["count", "-c"].include?(resolved_command)

      update_command_log(resolved_command)
      update_date_log
    end

    def display_date_log(all: false)
      header = ENV['LANG']&.start_with?('ja') ? "=== 日付別実行回数 ===" : "=== Execution Count by Date ==="
      no_log_message = ENV['LANG']&.start_with?('ja') ? "ログはまだありません。" : "No logs available."
      total_label = ENV['LANG']&.start_with?('ja') ? "合計" : "total"
      
      if !all
        header += ENV['LANG']&.start_with?('ja') ? "(過去1週間分)" : "(Past Week)"
      end
      
      return "#{header} ===\n#{no_log_message}\n" unless File.exist?(log_file)
      
      counts = {}
      File.readlines(log_file).each do |line|
        key, value = line.split
        next if key.nil? || value.nil? || key == "total"
        counts[key] = value.strip
      end
      
      # 全日付をカバーするようにする
      start_date = all ? Date.parse(counts.keys.min || Date.today.to_s) : (Date.today - 7)
      end_date = Date.today
      (start_date..end_date).each do |date|
        counts[date.to_s] ||= ""
      end
      
      total_count = counts.values.map(&:length).sum
      
      # 表示
      display = counts.sort.map do |date, stars|
        "#{date} #{stars}"
      end.join("\n")
      
      "#{header}\n#{display}\n#{total_label} #{total_count} 回\n"
    end

    def display_weekly_log
      header = ENV['LANG']&.start_with?('ja') ? "=== 過去1週間の実行履歴 ===" : "=== Execution History (Last 7 Days) ==="
      no_log_message = ENV['LANG']&.start_with?('ja') ? "ログはまだありません。" : "No logs available."
      
      logs = File.readlines(log_file).map(&:strip)
      one_week_ago = Date.today - 6
      today = Date.today
      
      # 過去7日間の日付を生成
      date_range = (one_week_ago..today).to_a
      
      # ログを日付ごとに整理
  log_counts = Hash.new(0)
  logs.each do |line|
    date_str, count = line.split(' ', 2)
    next unless date_str.match?(/^\d{4}-\d{2}-\d{2}$/) # 正しい日付形式か確認
    
    begin
      date = Date.parse(date_str)
      log_counts[date] += count.to_s.count('*') if date_range.include?(date)
    rescue Date::Error
      next
    end
  end
  
  # 出力を構築
  result = date_range.map do |date|
    stars = '*' * log_counts[date]
    "#{date} #{stars}"
  end
  
  "#{header}\n" + result.join("\n")
    end
    
    def display_command_log
      header = ENV['LANG']&.start_with?('ja') ? "=== コマンド別実行回数 ===" : "=== Execution Count by Command ==="
      no_log_message = ENV['LANG']&.start_with?('ja') ? "ログはまだありません。" : "No logs available."
      
      return "#{header}\n#{no_log_message}\n" unless File.exist?(command_log_file)

      counts = read_command_log
      
      display = counts.map { |cmd, stars| "#{cmd.ljust(15)} #{stars}" }.join("\n")

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
  
    private

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

    def update_command_log(command)
      command_counts = read_command_log

      command_counts[command] ||= ""
      command_counts[command] += "*"
      
      File.open(command_log_file, 'w') do |file|
        command_counts.each do |cmd, stars|
          file.puts "#{cmd} #{stars}"
        end
      end
    end

    def read_command_log
      command_counts = {}
      if File.exist?(command_log_file)
        File.readlines(command_log_file).each do |line|
          # スペースで分割し、コマンド名と実行履歴（*）を取得
          cmd, stars = line.split(' ', 2)
          command_counts[cmd] = stars&.strip || ""
        end
      end
      command_counts
    end

    def update_date_log
      today = Date.today.to_s
      date_counts = read_date_log

      date_counts[today] = (date_counts[today] || 0) + 1
      total_count = date_counts.values.sum

      File.open(log_file, 'w') do |file|
        date_counts.each { |date, count| file.puts "#{date} #{'*' * count}" }
        file.puts "total #{'*' * total_count}"
        file.puts "total #{total_count}回"
      end
    end

    def read_date_log
      date_counts = {}
      if File.exist?(log_file)
        File.readlines(log_file).each do |line|
          key, value = line.split
          next if key.nil? || value.nil? || key == "total"
          date_counts[key] = value.length
        end
      end
      date_counts
    end
  end
  
  class CountCLI < Thor
    # サブコマンドの説明をカスタマイズ
    def self.command_help(shell, command)
      header = MyHelp::Translations.translate(:count_command_help_header)
      shell.say header
      super
    end
    
    # クラス全体のヘルプのカスタマイズ
    def self.help(shell, *args)
      header = MyHelp::Translations.translate(:count_help_header)
      shell.say header
      list = printable_commands(true, false)
      filtered_list = list.reject { |command| command[0].include?("[COMMAND]") }
      max_command_length = filtered_list.map { |command| command[0].length }.max
      filtered_list.each do |command|
        formatted_command = command[0].ljust(max_command_length)
        shell.say("  #{formatted_command}  #{command[1]}")
      end
    end
    
    def self.command_help(shell, command)
      super
    end
    
    desc "history", MyHelp::Translations.translate(:count_history)
    def history
      puts CountLog.new.display_weekly_log
    end
    
    desc "log", MyHelp::Translations.translate(:count_log)
    def log
      puts CountLog.new.display_date_log(all: true)
    end
    
    desc "command", MyHelp::Translations.translate(:count_command)  
    def command
      puts CountLog.new.display_command_log
    end
    
    desc "list", MyHelp::Translations.translate(:count_list)  
    def list
      puts CountLog.new.display_list_log
    end
    
    desc "edit", MyHelp::Translations.translate(:count_edit)  
    def edit
      puts CountLog.new.display_edit_log
    end
    
    desc "help [COMMAND]", MyHelp::Translations.translate(:count_help)
    def help(command = nil)
      if command
        self.class.command_help(shell, command) 
      else
        self.class.help(shell)
      end
    end
  end
end
