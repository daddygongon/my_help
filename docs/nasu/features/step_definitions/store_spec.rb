def input
  command = "emacs_help --store [item]"
end

def backup
end

前提(/^バックアップをとっておきたい$/) do

end

もし(/^emacs_help \-\-store \[item\]と入力する$/) do
  input
end

ならば(/^入力したitemのバックアップが作られる$/) do
  backup
end
