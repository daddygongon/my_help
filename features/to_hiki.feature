# language: ja

#--to_hiki
機能:formatをhikiモードに変更する
一つ一つエディタで開いて変更するのがめんどくさい時に有益である

シナリオ: コマンドを入力してformatをhikiモードに変える
        前提 hikiモードに変更したい
        もし emacs_help --to_hikiと入力する
        ならば formatがhikiモードに変更される
