<div id="table-of-contents">
<h2>Table of Contents</h2>
<div id="text-table-of-contents">
<ul>
<li><a href="#">1. 概要</a></li>
<li><a href="#my_help">2. (my_helpで解決しようとする)問題点</a></li>
<li><a href="#">3. 特徴</a></li>
<li><a href="#">4. 使用法</a>
<ul>
<li><a href="#">4.1. 簡単な使用法</a></li>
<li><a href="#">4.2. インストール</a></li>
<li><a href="#alpine-linux-dockerfile">4.3. alpine linuxのためのDockerfile</a></li>
<li><a href="#help">4.4. 独自のhelpを作る方法</a></li>
<li><a href="#help">4.5. 独自helpを使えるように</a></li>
</ul>
</li>
<li><a href="#user-help">5. userの独自helpの達成方法</a></li>
<li><a href="#">6. どちらがいいか</a></li>
<li><a href="#uninstall">7. uninstall</a></li>
<li><a href="#sec-8">8. Rakefile</a></li>
</ul>
</div>
</div>


# 概要<a id="概要" name="概要"></a>


CUI(CLI)ヘルプのUsage出力を真似て，user独自のhelpを作成・提供するgem.

# (my\_helpで解決しようとする)問題点<a id="my_helpで解決しようとする問題点" name="my_helpで解決しようとする問題点"></a>


CUIやshell, 何かのプログラミング言語などを習得しようとする初心者は，
commandや文法を覚えるのに苦労します．少しのkey(とっかかり)があると
思い出すんですが，うろ覚えでは間違えて路頭に迷います．問題点は， 
-   manは基本的に英語
-   manualでは重たい
-   いつもおなじことをwebで検索して
-   同じとこ見ている
-   memoしても，どこへ置いたか忘れる

などです．

# 特徴<a id="特徴" name="特徴"></a>


これらをgem環境として提供しようというのが，このgemの目的です．
仕様としては， 
-   userが自分にあったmanを作成
-   雛形を提供
-   おなじformat, looks, 操作, 階層構造
-   すぐに手が届く
-   それらを追加・修正・削除できる

hikiでやろうとしていることの半分くらいはこのあたりのことなの
かもしれません．memoソフトでは，検索が必要となりますが，my\_helpは
key(記憶のとっかかり)を提供することが目的です．
RPGでレベル上げとかアイテムを貯めるようにして，
プログラミングでスキルを発展させてください．

物覚えの悪い作者は，人の名前をitem分けして，こそっと使っています．

# 使用法<a id="使用法" name="使用法"></a>



## 簡単な使用法<a id="簡単な使用法" name="簡単な使用法"></a>


> $ gem install my\_help

でも installがうまくいくと，defaultでmy\_help, my\_todo,
emacs\_helpが入ります．

emacs\_helpを動かしてみてください．

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

## インストール<a id="インストール" name="インストール"></a>


インストールですが，gemの標準とは違ったやり方になります．GithubからForkしてcloneします．
>$ git clone git@github.com:daddygongon/my\_help.git

あとの作業はbundleを使って行います．

これは，最後のrake
install:localをコマンドから実行する方法がわからんかったからですが．．．
-   helpファイルのpush共有とかも考えるとこれがいいのかも． -

home以下に置く方法と比較分析してください． -
lib/daddygongonにあたらしいhelpを置くようにしていましたが，helpに個人情報を入れるとgit
pushでさらしてしまうので，やめました．

まずは，

> $ bundle update

でmy\_help.gemspecに記述されている必要なgemsがbundleされます．

Could not locate
Gemfileとエラーが出た場合は、Gemfileのある場所を探し、その配下に移動してから再びコマンドを入力する．

用意されているコマンドは，

> $ bundle exec exe/my\_help

    Usage: my_help [options]
        -v, --version                    show program Version.
        -l, --list                       個別(specific)ヘルプのList表示.
        -e, --edit NAME                  NAME(例：test_help)をEdit編集.
        -i, --init NAME                  NAME(例：test_help)のtemplateを作成.
        -m, --make                       make executables for all helps.
        -c, --clean                      clean up exe dir.
            --install_local              install local after edit helps
            --delete NAME                delete NAME help

です．まず，-lでdefaultで入っているリストを見てください．

> $ bundle exec exe/my\_help -l

    "/usr/local/lib/ruby/gems/2.2.0/gems/my_help-0.2.1/lib/daddygongon"
    ["-l"]
    Specific help file:
      emacs_help

これで，CUIでemacs\_help, e\_hが用意されています．
これをいじって挙動に馴染んでください．
&#x2013;addとか&#x2013;editとかで，要素の追加や編集ができます．

## alpine linuxのためのDockerfile<a id="alpine-linuxのためのdockerfile" name="alpine-linuxのためのdockerfile"></a>


my\_helpをalpine
linux上で動作させるため、以下のDockerfileを作成しました。

    FROM alpine:3.7
    
    ENV http_proxy <YOUR PROXY HERE>
    ENV https_proxy <YOUR PROXY HERE>
    
    RUN apk update && apk upgrade
    RUN apk --update add \
      openssh git build-base libffi libffi-dev \
      ruby ruby-dev ruby-rake ruby-bundler
    
    RUN git clone https://github.com/daddygongon/my_help.git
    WORKDIR my_help
    
    RUN bundle update
    RUN bundle exec exe/my_help -m && rake install:local

プロキシは適宜書き換えてください。
ビルド時のアカウントに関するエラーを除けば大体は問題なく動作しています。

    # build an image named 'my-help'
    $ docker build -t my-help .
    ...
    
    # run a container
    $ docker run -it --rm my-help:latest emacs_help

## 独自のhelpを作る方法<a id="独自のhelpを作る方法" name="独自のhelpを作る方法"></a>


さて，独自のhelpを作る方法です．まずは，

> $ bundle exec exe/my\_help -i new\_help

"*Users/bob*.my\_help/new\_help"
"/Users/bob/Github/my\_help/lib/daddygongon/template\_help"

> $ cp *Users/bob/Github/my\_help/lib/daddygongon/template\_help
> /Users/bob*.my\_help/new\_help

で，new\_helpというtemplateが用意されます．-e
new\_helpで編集してください． YAML形式で，格納されています．サンプルが，

    my_help/lib/daddygongon

にあります．このあと，-mすると自動でnew\_helpがexeディレクトリーに追加されます．

## 独自helpを使えるように<a id="独自helpを使えるように" name="独自helpを使えるように"></a>


これは，

> $ bundle exec exe/my\_help -m

で自動的に行われるように修正しましたが，gem環境によっては正常にinstallできません．その場合は，以下にしたがって，手動で/usr/local/binなどにinstallする必要があります．my\_helpのdirectoryで

> $ git add -A

> $ git commit -m 'add new help'

> $ rake install:local

してください．さらにlocalへのinstallにはsudoがいるかもしれませ．

これで終わり．new\_helpや短縮形のn\_hでhelpが使えます．
もし使えないときは，bin
pathが通ってないので，terminalをnewしてください．

# userの独自helpの達成方法<a id="userの独自helpの達成方法" name="userの独自helpの達成方法"></a>


-   rake my\_helpでやっていたが，今は，my\_help -mに移行
-   @target dirをmy\_help/lib/daddygongonからENV['HOME']/.my\_helpに変更

exe中のファイルをrakeで自動生成． @target\_dirにそれらのdataを保存．
その名前からexe中に実行ファイルを自動生成させている．

    lib/daddygongon/
    └── emacs_help
    
    exe
    ├── e_h
    └── emacs_help

ということ．これは，

> $ my\_help -m

で実行される．これを

> $ rake install:local

すれば必要とするhelpがlocalな環境でbin dirに移され，CUI
commandとして実行可能になる．

たくさんの実行ファイルを/usr/loca/binに置くことになるので，あらたなmy\_helpを作成するときには

> $ gem uninstall my\_help

> $ gem uninstall emacs\_help

でそのdirをcleanにしておくことが望ましい．下のuninstallの項目を参照．

-mでやっている中身は以下の通り．

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

実装方法は，emacs\_helpに

1.  yaml形式でdataを入れ，command.runの入力ファイルとする
2.  hush形式でdataをいれ，それをrequireして使う

かのどちらかで実装．speedとかdebugを比較・検証する必要あり．
今の所，No.1の方を実装．No.2のためのhushデータは，

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

    ruby test.rb lib/daddygongon/emacs_help

で構築できる．実装してみて．

# どちらがいいか<a id="どちらがいいか" name="どちらがいいか"></a>


Rubyで日本語が使えるから，optionsを日本語にしてみた．

    Usage: eh [options]
        -v, --version                    show program Version.
        -c, --カーソル                       Cursor移動
        -p, --ページ                        Page移動
        -f, --ファイル                       File操作
        -e, --編集                         Edit操作
        -w, --ウィンドウ                      Window操作
        -b, --バッファ                       Buffer操作
        -q, --終了                         終了操作

半角，全角がoptparseでは適切に判断できない様で，表示があまり揃っていない．
しかし，初心者の振る舞いを見ているとわざわざ日本語に切り替えて打ち込むことは稀であり，
key wordをhelpで参照してshort optionで入力している．そこで，

    Usage: eh [options]
        -v, --version      show program Version.
        -c, --cursor       カーソル移動
        -p, --page         ページ移動
        -f, --file         ファイル操作
        -e, --edit         編集操作
        -w, --window       ウィンドウ操作
        -b, --buffer       バッファ操作
        -q, --quit         終了操作

としたほうがいいと提案する．アンケートを実施してみてほしい．

# uninstall<a id="uninstall" name="uninstall"></a>


my\_help -mでinstallするとEXECUTABLE DIRECTORYにhelpのexec
filesが自動で追加される． ~/.my\_helpを修正したときには，あらかじめ

> $ gem unistall my\_help

でそれらをuninstallしておくと良い．

> $ gem uninstall my\_help
> 
> Select gem to uninstall: 
> 1.  my\_help-0.1.0
> 2.  my\_help-0.2.0
> 3.  my\_help-0.2.1
> 4.  my\_help-0.2.2
> 5.  my\_help-0.2.3
> 6.  my\_help-0.3.0
> 7.  my\_help-0.3.1
> 8.  my\_help-0.3.2
> 9.  All versions
> 
> > 9 
> Successfully uninstalled my\_help-0.1.0 Successfully
> uninstalled my\_help-0.2.0 Remove executables: #my\_help#
> 
> in addition to the gem? [Yn] Y 
> Removing #my\_help# Successfully
> uninstalled my\_help-0.2.1 Successfully uninstalled my\_help-0.2.2
> Successfully uninstalled my\_help-0.2.3 Successfully uninstalled
> my\_help-0.3.0 Remove executables: test\_help
> 
> in addition to the gem? [Yn] Y 
> Removing test\_help Successfully
> uninstalled my\_help-0.3.1 Remove executables: e\_h, emacs\_help, m\_h,
> member\_help, my\_help, n\_h, new\_help, r\_h, ruby\_help, t\_h,
> template\_help
> 
> in addition to the gem? [Yn] Y 
> Removing e\_h Removing emacs\_help
> Removing m\_h Removing member\_help Removing my\_help Removing n\_h
> Removing new\_help Removing r\_h Removing ruby\_help Removing t\_h
> Removing template\_help Successfully uninstalled my\_help-0.3.2 \`\`\`

# Rakefile<a id="sec-8" name="sec-8"></a>

幾つかの環境設定用のtoolがRakefileに用意されている．

    # add .yml mode on ~/.emacs.d/init.el
    $ rake add_yml
    # clean up exe dir
    $ rake clean_exe
    # add .yml on all help files
    $ rake to_yml

-   add\_yml, to\_ymlは3.6から4.0へ移行する時に行ったhelpファイルの拡張子変更，
-   3.6では拡張子なしで4.0では'.yml'，に対する対応のために用意したツール．
-   add\_ymlは~/.my\_help/\*\_helpファイルを全て~/.my\_help/\*\_help.ymlに変える．
-   to\_ymlは~/.emacs.d/init.elに'.yml'の設定が書き込まれていない時，ruby-modeでemacsを起動するsciptを埋め込む．

clean\_exeは，githubへuploadする時に，開発者個人のexeファイルをrmして整頓する．