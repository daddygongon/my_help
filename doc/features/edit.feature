Feature: ファイルを編集する
  

  Scenario: コマンドを入力してファイルを編集する
    Given sampleファイルを編集したい
    When  "bundle exec bin/my_help_thor edit sample"  と入力する
    Then  sampleファイルが開く
    And   sampleファイルを書き換える



