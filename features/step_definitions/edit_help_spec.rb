def input
  command = "emacs_help --edit"
end

def open
#  f = File.open("~/.my_help/emacs_help.yml")
end

前提(/^emacs_helpのコマンドの編集がしたい$/) do

end

もし(/^emacs_help \-\-editと入力する$/) do
  input
end

ならば(/^~\/\.my_help\/emacs_help\.ymlがemacsで開かれる$/) do
  open
end
