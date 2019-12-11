Feature: my_help で作成された file を全て表示させる

  Scenario: コマンドを入力してmy_helpで作成されたfile 一覧を表示させる
    Given file 一覧を表示させたい
    When "bundle exec bin/my_help_thor list"と入力する
    Then file 一覧が表示される       

