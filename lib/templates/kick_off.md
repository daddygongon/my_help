# head: kickoff for wsl novice

# license: cc by Shigeto R. Nishitani, 2025

# initial_operation

最初(initial)の操作

1.  cd comp_a_25s
2.  git stash \# 変更をgitに無かったことに
3.  git pull origin main \# 最新のfilesをgitでpull(引っ張ってくる)
4.  cp bin/kick_off \~/bin \# 最新版のkick_offを\~/binにcopy
5.  cd \~/my_comp_a/python
6.  cp \~/comp_a_25s/python/hogehoge . \# hogehogeファイルを\'.\'にcp

# wsl shell commands

- cat : catenate \# 中身を出力する
  - cat results \| pbcopy(clip.exe)

<!-- -->

- bat : batcat

  - kick_off -f \| bat -l zsh

- python3 d1_print_calendar.py \> results.txt

- history

  - history -r \| tail -20 \| clip.exe

- tree, open, code .,

# directory(path) comms

- pwd : print working directory

- ls \[DIR\] : list \# defaultは\'.\'

- cd \[DIR\] : change directory \# defaultは\'`'          # '`\' tilde,
  ホームdirectoryを指す

# file comms

- mv : move
- cp : copy
- mkdir : make directory
- rm : remove
  - rm -rf DIR \# DIRごとremove

# editor key binds

-                       c-p(previous)
- c-a(ahead), c-b(back), c-f(forward), c-e(end)
-                       c-n(next)
- c-d(delete), c-k(kill-line), del
- c-y(yank, paste)

# capture comms

- Mac 
  - whole : Shift + Command + 3 
  - select: Shift + Command + 4 
  - window: Shift + Command + 4 , space 
  -  Desktopに保存
- Windows : 
  - Win + Shift + S, それからIcon操作
  - ピクチャ」-\>「スクリーンショット」に保存
