```
  
特殊キー操作
    c-f, controlキーを押しながら    'f'
    M-f, escキーを押した後一度離して'f'
      操作の中断c-g, 操作の取り消し(Undo) c-x u 

カーソル移動cursor
  c-f, move Forwrard,    前or右へ
  c-b, move Backwrard,   後or左へ
  c-a, go Ahead of line, 行頭へ
  c-e, go End of line,   行末へ
  c-n, move Next line,   次行へ
  c-p, move Previous line, 前行へ

ページ移動page
  c-v, move Vertical,          次のページへ
  M-v, move reversive Vertical,前のページへ
  c-l, centerise Line,       現在行を中心に
  M-<, move Top of file,    ファイルの先頭へ
  M->, move Bottom of file, ファイルの最後尾へ

ファイル操作file
  c-x c-f, Find file, ファイルを開く
  c-x c-s, Save file, ファイルを保存
  c-x c-w, Write file NAME, ファイルを別名で書き込む

編集操作editor
  c-d, Delete char, 一字削除
  c-k, Kill line,   一行抹消，カット
  c-y, Yank,        ペースト
  c-w, Kill region, 領域抹消，カット
  領域選択は，先頭or最後尾でc-spaceした後，最後尾or先頭へカーソル移動
  c-s, forward incremental Search WORD, 前へWORDを検索
  c-r, Reverse incremental search WORD, 後へWORDを検索
  M-x query-replace WORD1 <ret> WORD2：対話的置換(y or nで可否選択)

ウィンドウ操作window
  c-x 2, 2 windows, 二つに分割
  c-x 1, 1 windows, 一つに戻す
  c-x 3, 3rd window sep,縦線分割
  c-x o, Other windows, 次の画面へ移動

バッファー操作buffer(すでにopenしてemacsにバッファーされたfile)
  c-x b, show Buffer,   バッファのリスト
  c-x c-b, next Buffer, 次のバッファへ移動

終了操作quit
  c-x c-c, Quit emacs, ファイルを保存して終了
  c-z, suspend emacs,  一時停止，fgで復活
```
