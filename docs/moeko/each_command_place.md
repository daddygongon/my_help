# my_help 各コマンドを動かしている場所を整理する

testを動かす際にローカルで動かしているのか，currentで動かしているのか，
よくごちゃごちゃになるので，メモとしておいてみた．


## current working directoryを動かす．
2つ手段がある
今回はlistを表示させる場合を例として取り上げる．

一つ目は

```bash
> rake install :local
```
これで更新された．そして

```bash
> my_help list
```
をする


二つ目は

```bash
> bundle exec exe/my_help list
```
これのみ．


## localを動かす

```bash
> my_help list
```

