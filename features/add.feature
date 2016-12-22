#language: ja

#--add [item]
機能: 新しいitemをspecific_helpに追加する
specific_helpとは，ユーザが作成するそれぞれのヘルプである
新しいhelp画面を追加したい

シナリオ: コマンドを入力してspecific_helpにitemを追加する
        前提 新たなhelpコマンドを追加したい
        もし emacs_help --add[item]を入力する
        ならば ~/.my_help/emacs_help.ymlに新しいitemが自動的に追加される

