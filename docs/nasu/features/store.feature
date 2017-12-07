#language: ja

#--store [item]
機能: itemのバックアップを取る
バックアップとして残したいitemがあるときに使う

シナリオ: コマンドを入力してitemのバックアップをとる
        前提 バックアップをとっておきたい
        もし emacs_help --store [item]と入力する
        ならば 入力したitemのバックアップが作られる