# 永続的なexample_dirを作る

## はじめに
testを書いていくうちにtesterによって環境が違うようなものをtestしなければならないことがわかった.
このような条件になってしまうtestがmy_help listである.

## 方針

以下はmy_help listを実行した例である．これをみれば分かる様にここを実行してしまうと人によって異なる出力結果が出てしまう．

```bash
> my_help list
my_help list                                                                     
my_help called with ''

List all helps
      ruby: - ruby
       org: - emacs org-modeのhelp
      todo: - my todo
      HELP: - ヘルプのサンプル雛形
     emacs: - Emacs key bind
```
                         
これを統一する方法として前回tmp_dirをあげたが，方法の二つ目として永続的なexample_dir作成し，指すdirectoryを同じにするという方法をあげることにした．


## 方法

testの中にある永続的なexample_dirを利用する．

test/.my_helpの中に格納している．".my_help"の中のものを呼び出すにあたってdirectory指定をしなければならない．以下はdirectoryを指定した実行結果である．
これであればtesterの環境依存することなくtestが実行できる

```bash
> my_help list -d=\'../../test
my_help called with ''
default target dir : '../../test

List all helps
       org: - emacs org-modeのhelp
      todo: - my todo
my_help_test: - ヘルプのサンプル雛形
     emacs: - Emacs key bind
```

## test

```ruby:cli_spec.rb
  context "command list" do
   expected=/^my_help called with ''/
   let(:my_help){run_command("my_help list -d=\'../../test\'")}←ここでdirectory指定
   it { expect(my_help).to have_output(expected) }
  end
```

tmpdirを使うより分かりやすかった．



