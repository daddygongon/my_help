Feature: helpの編集

  Scenario: help を編集する.
    Given `$ bundle exec bin/my_help_thor list`でnew_helpが存在しない.
    When `$ bundle exec bin/my_help_thor new new_help`を実行する.
    And `$ bundle exec bin/my_help_thor edit new_help`実行して、全ての記述を削除する.
    Then ~/.my_help/new_help.orgが空ファイルである.