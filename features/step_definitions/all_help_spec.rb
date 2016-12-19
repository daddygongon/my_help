def input
  commands = "emacs_help --all"
end

def display_all
end

前提(/^複数のhelp画面を表示したい$/) do

end

もし(/^emacs_help \-\-allと入力する$/) do
  input
end

ならば(/^すべてのhelp画面が表示される$/) do
  display_all
end
