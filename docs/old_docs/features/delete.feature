Feature: helpの削除

  Scenario: help を1つ削除する.
    Given `$ bundle exec bin/my_help_thor list`でnew_helpが1つ存在する.
    When `$ bundle exec bin/my_help_thor delete new_help`を実行する.
    And `$ bundle exec bin/my_help_thor list`を実行する.
    Then new_helpが存在しない.