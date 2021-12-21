# editを立ち上げるtestを書いてみた．

## 初めに

my_helpで指定したファイルをeditorで立ち上げるコマンドは，

```bash
> my_help edit [ファイル名]
```

である．

すると，

```bash
> my_help set editor [editor名(例えばemacsなど)]
```

で指定したeditorが立ち上がるようになる．

## やりたいこと

大きく2つある．

一つ目がeditorを閉じた後，

```bash
my_help called with 'ファイル名'
"/Users/higashibatamoeko/.my_help/ファイル名.org"
```

と表示される．これがちゃんと表示されるか．
これは従来通りのテストで解決できそうである．

もう一つが，

editorが立ち上がっているのか確かめるテストを行いたいが，現在やり方を考え中．





