Feature: helpの作成

  Scenario: help を1つ作成する.
    Given `$ bundle exec bin/my_help_thor list`でnew_helpが存在しない.
    When `$ bundle exec bin/my_help_thor new new_help`を実行する.
    And `$ bundle exec bin/my_help_thor list`を実行する.
    Then new_helpが存在する.