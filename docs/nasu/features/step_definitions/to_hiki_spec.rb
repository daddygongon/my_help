def input
  command = "eacs_help --to_hiki"
end

def convert
end

前提(/^hikiモードに変更したい$/) do

end

もし(/^emacs_help \-\-to_hikiと入力する$/) do
  input
end

ならば(/^formatがhikiモードに変更される$/) do
  convert
end
