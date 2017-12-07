def input
  command = "emacs_help --add [item]"
end

def add
end

前提(/^新たなhelpコマンドを追加したい$/) do
  
end

もし(/^emacs_help \-\-add\[item\]を入力する$/) do 
  input
end

ならば(/^~\/\.my_help\/emacs_help\.ymlに新しいitemが自動的に追加される$/) do 
  add
end
