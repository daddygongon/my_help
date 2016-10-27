# 名前

petit_help, general_help, my_help, ...

# 概要

CUI(CLI)ヘルプのUsage出力を真似て，user独自のhelpを作成・提供するgem.

# 問題点
CUIやshell, 何かのプログラミング言語などを習得しようとする初心者は，
commandや文法を覚えるのに苦労します．少しのkey(とっかかり)があると
思い出すんですが，うろ覚えでは間違えて路頭に迷います．問題点は，
- manは基本的に英語
- manualでは重たい
- いつもおなじことをwebで検索して
- 同じとこ見ている
- memoしても，どこへ置いたか忘れる

などです．

# 特徴
これらをgem環境として提供しようというのが，このgemの目的です．
仕様としては，
- userが自分にあったmanを作成
- 雛形を提供
  - おなじformat, looks, 操作, 階層構造
- すぐに手が届く
- それらを追加・修正・削除できる

hikiでやろうとしていることの半分くらいはこのあたりのことなの
かもしれません．memoソフトでは，検索が必要となりますが，my_helpは
key(記憶のとっかかり)を提供することが目的です．

# userの独自helpの達成方法
exe中のファイルをrakeで自動生成．
./lib/daddygongon/にそれらのdataを保存．以下ではその名前から
exe中に実行ファイルを自動生成させている．
```
lib/daddygongon/
└── emacs_help

exe
├── e_h
└── emacs_help
```
ということ．これは，
```
rake my_help
```
で実行される．これを
```
rake install:local
```
すれば必要とするhelpがlocalな環境で表示される．

たくさんの実行ファイルを/usr/loca/binに置くことになるので，
```
gem uninstall my_help
gem uninstall emacs_help
```
でそこをcleanにしておくことが望ましい．
```ruby
desc "make own help from lib/daddygongon/files"
task :my_help do
  exe_cont="#!/usr/bin/env ruby\n"
  user_name = 'daddygongon'
  p entries=Dir.entries(File.join('.','lib',user_name))[2..-1]
  entries.each{|file|
    p file
    p file_name=file.split('_')
    target_files = [file, file_name[0][0]+"_"+file_name[1][0]]
    p cont_name = File.join(user_name,file)
#    exe_cont << "require '#{cont_name}'\n"
    exe_cont << "require 'emacs_help'\n"
    exe_cont << "EmacsHelp::Command.run(ARGV)\n"
    target_files.each{|name|
      p target=File.join('exe',name)
      File.open(target,'w'){|file|
        file.print exe_cont
      }
      FileUtils.chmod('a+x', target, :verbose => true)
    }
  }
end
```

この後の実装方法は，emacs_helpに

1. yaml形式でdataを入れ，command.runの入力ファイルとする
1. hush形式でdataをいれ，それをrequireして使う

かのどちらかで実装．speedとかdebugを比較・検証する必要あり．

# どちらがいいか
Rubyで日本語が使えるから，optionsを日本語にしてみた．
```
Usage: eh [options]
    -v, --version                    show program Version.
    -c, --カーソル                       Cursor移動
    -p, --ページ                        Page移動
    -f, --ファイル                       File操作
    -e, --編集                         Edit操作
    -w, --ウィンドウ                      Window操作
    -b, --バッファ                       Buffer操作
    -q, --終了                         終了操作
```
半角，全角がoptparseでは適切に判断できない様で，表示があまり揃っていない．
しかし，初心者の振る舞いを見ているとわざわざ日本語に切り替えて打ち込むことは稀であり，
key wordをhelpで参照してshort optionで入力している．そこで，
```
Usage: eh [options]
    -v, --version      show program Version.
    -c, --cursor       カーソル移動
    -p, --page         ページ移動
    -f, --file         ファイル操作
    -e, --edit         編集操作
    -w, --window       ウィンドウ操作
    -b, --buffer       バッファ操作
    -q, --quit         終了操作
```
としたほうがいいと提案する．アンケートを実施してみてほしい．
