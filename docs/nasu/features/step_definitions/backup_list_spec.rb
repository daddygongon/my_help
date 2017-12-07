def input
  command = "emacs_help --backup_list"
end

def display_list
end

前提(/^バックアップのリストを見たい$/) do

end

もし(/^emacs_help \-\-backup_listを入力する$/) do
    input
end

ならば(/^バックアップしているitemのリストが表示される$/) do
  display_list
end
