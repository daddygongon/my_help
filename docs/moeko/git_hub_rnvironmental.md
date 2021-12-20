# 初めに

originが教授になっている為，これをまず自分に変えてupstreamを教授に変える

## 方法


まず今の状況を見る

```bash
> git remote -v
origin	git@github.com:daddygongon/my_help.git (fetch)
origin	git@github.com:daddygongon/my_help.git (push)
```
originがdaddygongon(教授のもの)になっている.
なので下記を実行すると，

```bash
> pull_request
```

教授のmy_helpのページに飛ぶ．
そのページのForkをクリックし，自分のアカウント名(mek001)をクリックしfolkする．
codeからSSHをコピーする．

originを自分に書き換えたいため，一旦originを消す．

```bash
> git remote rm origin 
```

そこから以下の作業を行う．

```bash
> git remote add origin SSHコピーしたものを貼り付け
```

```bash
> git remote add upstream 前originだった教授のgit@hubから始まるものを貼り付け
```

すると,

```bash
> get remote -v
origin	git@github.com:mek001/my_help.git (fetch)
origin	git@github.com:mek001/my_help.git (push)
upstream	git@github.com:daddygongon/my_help.git (fetch)
upstream	git@github.com:daddygongon/my_help.git (push)
```

このようにoriginに自分のアカウント名が，upstreamに教授のアカウント名が表示される．

そして，いつも通り

```>bash
> git add -A
```

```bash
> git commit
```

```bash
> git pull upstream main

~中略~
Auto-merging spec/my_help_spec.rb
CONFLICT (content): Merge conflict in spec/my_help_spec.rb
Auto-merging spec/cli_spec.rb
CONFLICT (content): Merge conflict in spec/cli_spec.rb
Auto-merging .rspec_status
CONFLICT (content): Merge conflict in .rspec_status
Automatic merge failed; fix conflicts and then commit the result.

```

するのだが，pullした時にconflictが起こる．
これは，同時に同じファイルをいじったりすると起こる現象である．
PCは自動でmergeしようとするが，それが出来なかったと返ってくる．
解決法としては表示されているファイルを一つずつ解消していく．具体的な解消法は次の記事に書くことにする．











