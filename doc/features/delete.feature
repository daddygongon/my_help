Feature: my_help で作成された file を削除する

  Scenario: コマンドを入力してsample_new.yml fileを削除する
    Given sample_new.yml file を削除したい
    When "bundle exec bin/my_help_thor delete sample_new" と入力
    Then file を削除する