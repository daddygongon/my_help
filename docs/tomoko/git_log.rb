# -*- coding: utf-8 -*-
array = []
unit_array = []
commits = []

File.open("git_commit.txt","r") do |file|
  File.open("git_commit_log.org","w") do |f|
    minus = 0
    plus = 0

#    file.encode!('UTF-8','UTF-8',:invalid => :replace)
    file.each_line do |file_conts|
      filename = file_conts.chomp
      filename.strip!   #空白文字削除

      new_filename = File.basename(filename) #if /.*\.txt$/
      array = new_filename.scan(/\w+\.\w+/)
      array.select!{ |x|    #破壊的メソッドselect!
        x.include?(".org") || x.include?(".html") || x.include?(".pdf") || x.include?(".tex")
      }
      if array != []
        unit_array.push(array)
        unit_array.flatten!
      end


      if file_conts.start_with? "-" then
        minus = minus + 1
      elsif file_conts.start_with? "+" then
        plus = plus + 1
      end
      commits.push(file_conts)
      commits.select!{ |x|
        x.include?("Author")
      }


    end
    f.puts commits.join("\n").chomp,"\n"
    f.puts unit_array.uniq.join("\n"),"\n"

    f.print "削除した行数：" , minus ,"\n"
    f.print "追加した行数：" , plus ,"\n"
    f.print "変更した行数：" , minus+plus ,"\n"
  end

end
#git_commit.txtに書かれた変更の行数をカウントするプログラム．誰のか，どのファイルかは明記されていない．
