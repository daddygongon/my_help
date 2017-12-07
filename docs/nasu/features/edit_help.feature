# language: ja
#--edit
機能: helpコマンドの追加や削除，編集をするためのeiditを開く
emacs_helpと入力したときに出てくるhelpのコマンドの追加や削除，編集ができる

シナリオ: コマンドを入力してeditを開く
        前提 emacs_helpのコマンドの編集がしたい
        もし emacs_help --editと入力する
        ならば ~/.my_help/emacs_help.ymlがemacsで開かれる