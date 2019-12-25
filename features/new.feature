Feature: my_helpで新しいfileを作成する

  Scenario: コマンドを入力してsample_new.yml fileを作成する
    Given sample_new.yml file を作成したい
    When "bundle exec bin/my_help_thor new sample_new " と入力する
    Then sample_new file が作成される       
