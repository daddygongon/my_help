#language: ja

#--remove [item]
機能: helpのitemを消す
いらなくなったitemを消したいときに使う
シナリオ: コマンドを入力してitemを消す
        前提 いらないitemを消したい
        もし emacs_help remove [item]
        ならば 入力したitemが消える