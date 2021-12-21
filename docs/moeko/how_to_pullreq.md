# git hubでpull requestを送る

## pull_requestとは?
アプリを共同で開発している際に，他の人が作った箇所の間違いに気づいたりした時に，これではここが動かなかったということをコメント付きで送れるgithubの機能である．

## 方法

まずいつも通り更新をする

```bash
> git add -A
```

```bash
> git commit
```

```bash
> git push origin main
```

conflictもなく無事に更新できたら，

```bash
> pull_request
```

とすると，mek001/my_helpのgithubのページが開く．
1. そのページから左上のPull requestを開く．
2. 緑のボタンのNew pull requestを開く．
3. create new pull requestを押す．
4. コメントを書く欄が出てくるため，そこに適宜コメントを入れる．
5. そしてCreate pull requestを押すとpull requestができたことになる．








