# coding: utf-8
module MyHelp
  module Translations
    LANGUAGES = {
      'EN' => {
        version: "show version",
        add_defaults: "add defaults org files",
        init: "initialize my_help environment",
        set: "set editor or ext",
        list: "list helps",
        edit: "edit help",
        new: "mk new HELP",
        place: "place template on cwd",
        delete: "delete HELP",
        hello: "hello",
        git: "git operations",
        help: "Describe available commands or one specific command",
        count: "Display history of my_help",
        count_help: "Commands available in 'count'",
        count_command_help_header: "Describe subcommands or one specific subcommand",
        count_help_header: "my_help count commands:",
        count_log: "Display execution count by date",
        count_command: "Display execution count by command",
        count_list: "Display usage history of 'list'",
        count_edit: "Display edited file history of 'edit'",
        count_history: "Display execution count by date per week",
      },
      'JP' => {
        version: "バージョンを表示",
        add_defaults: "デフォルトのorgファイルを追加",
        init: "my_help環境を初期化",
        set: "エディタや拡張子を設定",
        list: "helpsファイルをリスト表示",
        edit: "HELPを編集",
        new: "新しいHELPを作成",
        place: "テンプレートを現在のディレクトリに配置",
        delete: "HELPを削除",
        hello: "こんにちは",
        git: "gitの操作",
        help: "利用可能なコマンドまたは特定のコマンドを説明する",
        count: "my_helpの履歴を表示",
        count_help: "'count'で使用できるコマンド",
        count_command_help_header: "サブコマンドまたは特定のサブコマンドを説明する",
        count_help_header: "countの使用可能なコマンド一覧：",
        count_log: "日付別の実行回数を表示",
        count_command: "コマンド別の実行回数を表示",
        count_list: "'list' の使用履歴を表示",
        count_edit: "'edit' で編集されたファイルの履歴を表示",
        count_history: "1週間の日付別の実行回数を表示",
      }
    }
    
    def self.translate(key)
      language = ENV['LANG'].to_s.start_with?('ja') ? 'JP' : 'EN'
      LANGUAGES[language][key]
    end
  end
end
