#language: ja

#--remove [item]
機能: specific_helpのitemを消す
いらなくなったitemを消したいときに使う

シナリオ: コマンドを入力してitemを消す
        前提 いらないitemを消したい
        もし emacs_help remove [item]
        ならば ~/.my_help/emacs_help.ymlからitemが消える