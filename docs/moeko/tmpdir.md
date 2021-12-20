# temdirをtestで使えるように理解する

## 初めに

tmpdirをtestに書こうと思ったが，理解に苦しんだため自分が理解した所までをメモとして残しておくことにした．

tmpdirはlearnerでも使っていた．
なんでtmpdirを使わないといけないのか，それはlistを表示させた時に生じる問題があるからだ．

```bash
>  my_help list                                                                     
my_help called with ''

List all helps
      ruby: - ruby
       org: - emacs org-modeのhelp
      todo: - my todo
      HELP: - ヘルプのサンプル雛形
     emacs: - Emacs key bind
```

上記はmy_help listを表示させた時である．
これではtesterによって環境が違う為，テストに再現性がなくなってしまう．これが問題である．

そこでtmpdirを使ってこの問題を解消しようとした．


## temdirとは

temporary = 一時的

temporary file = 一時的なファイル

その名も通りそのclassの中のみで一時的に作成されるファイルであり，そのclassを抜けるときに削除されるものである．

## .my_helpでのtemporary file の作り方

ここではtemporary fileの作り方を記す．
まず，Dir.tmpdirを表示させる．

```bash
> p Dir.tmpdir
"/var/folders/39/679vp6x167n83277zc8_nrqr0000gn/T"←環境に依存するため人によって違う
=> "/var/folders/39/679vp6x167n83277zc8_nrqr0000gn/T"←環境に依存するため人によって違う
```
Dir.tmpdirをtmpdirに代入する．

```bash
> tmpdir = Dir.tmpdir
```

File.joinを使ってtemporary fileを作る

```bash
> Dir.mkdir(File.join(tmpdir,'.my_help')
```

Dir.mkdirは()で指定された新しいディレクトリを作る．
()の中ではFile.joinでtmpdirと.my_helpをくっつける．

```bash
> File.exist?(tmpdir)
```

これでtpmdirが消えることになる．

## 方針・わからないこと

tmpdirでできることは理解した．ただテストでどう活かしていけば良いのかがわからない．

