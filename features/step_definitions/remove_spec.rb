def input
  command = "emacs_help remove [item]"
end

def remove
end

前提(/^いらないitemを消したい$/) do

end

もし(/^emacs_help remove \[item\]$/) do
  input
end

ならば(/^~\/\.my_help\/emacs_help\.ymlからitemが消える$/) do
  remove
end
