Feature: helpの一覧表示

  Scenario: help の一覧を表示する
    Given `$ find ~/.my_help -name "*.org" | xargs head -n 1 | grep -v '#+STARTUP: indent nolineimages'`で確認できるhelpがファイルが~/.my_helpに存在する.
    When `$ bundle exec bin/my_help_thor list`を実行する.
    Then ~/.my_helpのファイル名相当の項目がlistに全て存在する.