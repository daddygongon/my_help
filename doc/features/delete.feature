Feature: helpの削除

  Scenario: help を1つ削除する.
    Given `$ bundle exec bin/my_help_thor list`でnew_helpが存在する.
    AND `$ bundle exec bin/my_help_thor new new_help`によってnew_helpを作成する.
    When `$ bundle exec bin/my_help_thor delete new_help`を実行する.
    AND `$ bundle exec bin/my_help_thor list`を実行する.
    Then new_helpが存在しない.