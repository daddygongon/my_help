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
        count: "Display the execution count of my_help [log|command|list|edit] for detailed information"
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
        help: "使用可能なコマンドまたは特定のコマンドについて説明",
        count: "my_helpを実行した回数を表示[log|command|list|edit]で詳細確認"
      }
    }
    
    def self.translate(key)
      language = ENV['LANG'].to_s.start_with?('ja') ? 'JP' : 'EN'
      LANGUAGES[language][key]
    end
  end
end
