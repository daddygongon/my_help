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

# 使用法
## インストール
インストールですが，gemの標準とは違ったやり方になります．GithubからForkしてcloneします．
```
git clone git@github.com:daddygongon/my_help.git
```
あとの作業はbundleを使って行います．これは，最後のrake install:localをコマンドから実行する方法がわからんかったからですが．．．helpファイルのpush共有とかも考えるとこれがいいのかも．

用意されているコマンドは，

```
bob%  bundle exec exe/my_help
Usage: my_help [options]
    -v, --version                    show program Version.
    -l, --list                       個別(specific)ヘルプのList表示.
    -e, --edit NAME                  NAME(例：test_help)をEdit編集.
    -i, --init NAME                  NAME(例：test_help)のtemplateを作成.
    -m, --make                       make and install:local all helps.
    -c, --clean                      clean up exe dir.
```
です．まず，-lでdefaultで入っているリストを見てください．

```
bob%  bundle exec exe/my_help -l
"/usr/local/lib/ruby/gems/2.2.0/gems/my_help-0.2.1/lib/daddygongon"
["-l"]
Specific help file:
  emacs_help
  test_help
```
これで，CUIでemacs_help, e_h, test_help, t_hが用意されています．少し振る舞いに慣れてください．

## 独自のhelpを作る方法
さて，独自のhelpを作る方法です．まずは，

```
bob%  bundle exec exe/my_help -i new_help
"/usr/local/lib/ruby/gems/2.2.0/gems/my_help-0.2.1/lib/daddygongon"
["-i", "new_help"]
"/usr/local/lib/ruby/gems/2.2.0/gems/my_help-0.2.1/lib/daddygongon/new_help"
"/usr/local/lib/ruby/gems/2.2.0/gems/my_help-0.2.1/lib/my_help/template_help"
cp /usr/local/lib/ruby/gems/2.2.0/gems/my_help-0.2.1/lib/my_help/template_help 
  /usr/local/lib/ruby/gems/2.2.0/gems/my_help-0.2.1/lib/daddygongon/new_help
```
で，new_helpというtemplateが用意されます．-e new_helpで編集してください．そのあと，-mすると自動でnew_helpがexeディレクトリーに追加されます．

## 独自helpを使えるように
最後，my_helpのdirectoryで
```
 git add -A
 git commit -m 'add new help'
 rake install:local
```
してください．

これで終わり．new_helpや短縮形のn_hでhelpが使えます．
もし使えないときは，bin pathが通ってないので，terminalをnewしてください．

# userの独自helpの達成方法
(rake my_helpでやっていたが，今は，my_help -mに移行)

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

Rakefileの中身は以下の通り．
```
in Rakefile
```

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
    p cont_name = File.join('lib',user_name,file)
    exe_cont << "require 'my_help'\n"
    exe_cont << "help_file = File.expand_path(\"../../#{cont_name}\", __FILE__)\n"
    exe_cont << "MyHelp::Command.run(help_file, ARGV)\n"
    target_files.each{|name|
      p ''
      p target=File.join('exe',name)
      File.open(target,'w'){|file|
        print exe_cont
        file.print exe_cont
      }
      FileUtils.chmod('a+x', target, :verbose => true)
    }
  }
end
```

実装方法は，emacs_helpに

1. yaml形式でdataを入れ，command.runの入力ファイルとする
1. hush形式でdataをいれ，それをrequireして使う

かのどちらかで実装．speedとかdebugを比較・検証する必要あり．
今の所，No.1の方を実装．No.2のためのhushデータは，

```ruby
require 'yaml'
require 'pp'

pp YAML.load(File.read(ARGV[0]))
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
