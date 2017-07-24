# 名前

my_help

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
RPGでレベル上げとかアイテムを貯めるようにして，
プログラミングでスキルを発展させてください．

物覚えの悪い作者は，人の名前をitem分けして，こそっと使っています．


# 使用法
## インストール
インストールですが，gemの標準とは違ったやり方になります．GithubからForkしてcloneします．
```
git clone git@github.com:daddygongon/my_help.git
```
あとの作業はbundleを使って行います．

これは，最後のrake install:localをコマンドから実行する方法がわからんかったからですが．．．
- helpファイルのpush共有とかも考えるとこれがいいのかも．
- home以下に置く方法と比較分析してください．
  - lib/daddygongonにあたらしいhelpを置くようにしていましたが，helpに個人情報を入れるとgit pushでさらしてしまうので，やめました．

用意されているコマンドは，

```
bob%  bundle exec exe/my_help
Usage: my_help [options]
    -v, --version                    show program Version.
    -l, --list                       個別(specific)ヘルプのList表示.
    -e, --edit NAME                  NAME(例：test_help)をEdit編集.
    -i, --init NAME                  NAME(例：test_help)のtemplateを作成.
    -m, --make                       make executables for all helps.
    -c, --clean                      clean up exe dir.
        --install_local              install local after edit helps
        --delete NAME                delete NAME help
```
です．まず，-lでdefaultで入っているリストを見てください．

```
bob%  bundle exec exe/my_help -l
"/usr/local/lib/ruby/gems/2.2.0/gems/my_help-0.2.1/lib/daddygongon"
["-l"]
Specific help file:
  emacs_help
```
これで，CUIでemacs_help, e_hが用意されています．

```
emacsのキーバインド

特殊キー操作
  c-f, controlキーを押しながら    'f'
  M-f, escキーを押した後一度離して'f'
    操作の中断c-g, 操作の取り消し(Undo) c-x u
     cc by Shigeto R. Nishitani, 2016
Usage: e_h [options]
    -v, --version                    show program Version.
    -c, --cursor                     Cursor移動
    -e, --編集                         Edit操作
    -f, --ファイル                       File操作
    -q, --終了                         終了操作
    -p, --ページ                        Page移動
    -w, --ウィンドウ                      Window操作
    -b, --バッファ                       Buffer操作
    -m, --mode                       モード切り替え
        --edit                       edit help contents
        --to_hiki                    convert to hikidoc format
        --all                        display all helps
        --store [item]               store [item] in back
        --remove [item]              remove [item] in back
        --add [item]                 add new [item]
```
少し振る舞いに慣れてください．

## 独自のhelpを作る方法
さて，独自のhelpを作る方法です．まずは，

```
bob%  bundle exec exe/my_help -i new_help
"/Users/bob/.my_help/new_help"
"/Users/bob/Github/my_help/lib/daddygongon/template_help"
cp /Users/bob/Github/my_help/lib/daddygongon/template_help /Users/bob/.my_help/new_help
```
で，new_helpというtemplateが用意されます．-e new_helpで編集してください．
YAML形式で，格納されています．サンプルが，
```
my_help/lib/daddygongon
```
にあります．このあと，-mすると自動でnew_helpがexeディレクトリーに追加されます．

## 独自helpを使えるように
これは，
```
 bob%  bundle exec exe/my_help -m
```
で自動的に行われるように修正しましたが，gem環境によっては正常にinstallできません．その場合は，以下にしたがって，手動で/usr/local/binなどにinstallする必要があります．my_helpのdirectoryで
```
 git add -A
 git commit -m 'add new help'
 rake install:local
```
してください．さらにlocalへのinstallにはsudoがいるかもしれませ．

これで終わり．new_helpや短縮形のn_hでhelpが使えます．
もし使えないときは，bin pathが通ってないので，terminalをnewしてください．

# userの独自helpの達成方法
- rake my_helpでやっていたが，今は，my_help -mに移行
- @target dirをmy_help/lib/daddygongonからENV['HOME']/.my_helpに変更

exe中のファイルをrakeで自動生成．
@target_dirにそれらのdataを保存．
その名前からexe中に実行ファイルを自動生成させている．
```
lib/daddygongon/
└── emacs_help

exe
├── e_h
└── emacs_help
```
ということ．これは，
```
my_help -m
```
で実行される．これを
```
rake install:local
```
すれば必要とするhelpがlocalな環境でbin dirに移され，CUI commandとして実行可能になる．

たくさんの実行ファイルを/usr/loca/binに置くことになるので，あらたなmy_helpを作成するときには
```
gem uninstall my_help
gem uninstall emacs_help
```
でそのdirをcleanにしておくことが望ましい．下のuninstallの項目を参照．

-mでやっている中身は以下の通り．
```ruby
    def make_help
      Dir.entries(@target_dir)[2..-1].each{|file|
        next if file[0]=='#' or file[-1]=='~'
        exe_cont="#!/usr/bin/env ruby\nrequire 'specific_help'\n"
        exe_cont << "help_file = File.join(ENV['HOME'],'.my_help','#{file}')\n"
        exe_cont << "SpecificHelp::Command.run(help_file, ARGV)\n"
        [file, short_name(file)].each{|name|
          p target=File.join('exe',name)
          File.open(target,'w'){|file| file.print exe_cont}
          FileUtils.chmod('a+x', target, :verbose => true)
        }
      }
      install_local
    end

    def install_local
      #中略
      system "git add -A"
      system "git commit -m 'update exe dirs'"
      system "Rake install:local"
    end

```

実装方法は，emacs_helpに

1. yaml形式でdataを入れ，command.runの入力ファイルとする
1. hush形式でdataをいれ，それをrequireして使う

かのどちらかで実装．speedとかdebugを比較・検証する必要あり．
今の所，No.1の方を実装．No.2のためのhushデータは，

```ruby
# -*- coding: utf-8 -*-
require 'yaml'
require 'pp'
yaml =<<EOF
:file:
  :opts:
    :short: "-f"
  :cont:
  - c-x c-f, Find file, ファイルを開く
  - c-x c-s, Save file, ファイルを保存
EOF
pp data=YAML.load(yaml)
print YAML.dump(data)


data0={:file=>
  {:opts=>{:short=>"-f", :long=>"--ファイル", :desc=>"File操作"},
   :title=>"ファイル操作file",
   :cont=>
    ["c-x c-f, Find file, ファイルを開く
     c-x c-s, Save file, ファイルを保存
     c-x c-w, Write file NAME, ファイルを別名で書き込む"]}}

print YAML.dump(data0)
```

```
ruby test.rb lib/daddygongon/emacs_help
```

で構築できる．実装してみて．


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

# uninstall
my_help -mでinstallするとEXECUTABLE DIRECTORYにhelpのexec filesが自動で追加される．
~/.my_helpを修正したときには，あらかじめ
```
gem unistall my_help
```
でそれらをuninstallしておくと良い．

```
bob% gem uninstall my_help

Select gem to uninstall:
 1. my_help-0.1.0
 2. my_help-0.2.0
 3. my_help-0.2.1
 4. my_help-0.2.2
 5. my_help-0.2.3
 6. my_help-0.3.0
 7. my_help-0.3.1
 8. my_help-0.3.2
 9. All versions
> 9
Successfully uninstalled my_help-0.1.0
Successfully uninstalled my_help-0.2.0
Remove executables:
	#my_help#

in addition to the gem? [Yn]  Y
Removing #my_help#
Successfully uninstalled my_help-0.2.1
Successfully uninstalled my_help-0.2.2
Successfully uninstalled my_help-0.2.3
Successfully uninstalled my_help-0.3.0
Remove executables:
	test_help

in addition to the gem? [Yn]  Y
Removing test_help
Successfully uninstalled my_help-0.3.1
Remove executables:
	e_h, emacs_help, m_h, member_help, my_help, n_h, new_help, r_h, ruby_help, t_h, template_help

in addition to the gem? [Yn]  Y
Removing e_h
Removing emacs_help
Removing m_h
Removing member_help
Removing my_help
Removing n_h
Removing new_help
Removing r_h
Removing ruby_help
Removing t_h
Removing template_help
Successfully uninstalled my_help-0.3.2
```

# Rakefile
幾つかの環境設定用のtoolがRakefileに用意されている．
```
rake add_yml          # add .yml mode on ~/.emacs.d/init.el
rake clean_exe        # clean up exe dir
rake to_yml           # add .yml on all help files
```
add_yml, to_ymlは3.6から4.0へ移行する時に行ったhelpファイルの拡張子変更，
3.6では拡張子なしで4.0では'.yml'，に対する対応のために用意したツール．
add_ymlは~/.my_help/*_helpファイルを全て~/.my_help/*_help.ymlに変える．
to_ymlは~/.emacs.d/init.elに'.yml'の設定が書き込まれていない時，ruby-modeでemacsを起動するsciptを埋め込む．

clean_exeは，githubへuploadする時に，開発者個人のexeファイルをrmして整頓する．
