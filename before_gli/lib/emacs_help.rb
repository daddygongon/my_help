# -*- coding: utf-8 -*-
require "optparse"
require "emacs_help/version"

module EmacsHelp
  class Command
    def self.run(argv=[])
      print "\n特殊キー操作"
      print "\tc-f, controlキーを押しながら    'f'\n"
      print "\t\tM-f, escキーを押した後一度離して'f'\n"
      print "\t操作の中断c-g, 操作の取り消し(Undo) c-x u \n"
      new(argv).execute
    end

    def initialize(argv=[])
      @argv = argv
      data_path = File.join(ENV['HOME'], '.hikirc')
    end

    def execute
      @argv << '--help' if @argv.size==0
      command_parser = OptionParser.new do |opt|
        opt.on('-v', '--version','show program Version.') { |v|
          opt.version = EmacsHelp::VERSION
          puts opt.ver
        }
        opt.on('-c','--カーソル','Cursor移動') {cursor_move}
        opt.on('-p','--ページ','Page移動') {page_move}
        opt.on('-f','--ファイル','File操作') {file}
        opt.on('-e','--編集','Edit操作') {edit}
        opt.on('-w','--ウィンドウ','Window操作') {window}
        opt.on('-b','--バッファ','Buffer操作') {buffer}
        opt.on('-q','--終了','終了操作') {quit}
        opt.on('--edit','edit help contents'){edit_help}                                                               
        opt.on('--edit','edit help contentsを開く'){edit_help}
        #        opt.on('--to_hiki','convert to hikidoc format'){to_hiki}                                                       
        opt.on('--to_hiki','hikiのformatに変更する'){to_hiki}
        #        opt.on('--all','display all helps'){all_help}                                                                  
        opt.on('--all','すべてのhelp画面を表示させる'){all_help}
        #        opt.on('--store [item]','store [item] in backfile'){|item| store(item)}                                        
        opt.on('--store [item]','store [item] でback upをとる'){|item| store(item)}
        #        opt.on('--remove [item]','remove [item] and store in backfile'){|item| remove(item) }                          
        opt.on('--remove [item]','remove [item] back upしてるlistを消去する'){|item| remove(item) }
        #       opt.on('--add [item]','add new [item]'){|item| add(item) }                                                      
        opt.on('--add [item]','add new [item]で新しいhelpを作る'){|item| add(item) }
        #        opt.on('--backup_list [val]','show last [val] backup list'){|val| backup_list(val)}                            
        opt.on('--backup_list [val]','back upしているlistを表示させる'){|val| backup_list(val)}

      end
      begin
        command_parser.parse!(@argv)
      rescue=> eval
        p eval
      end
      exit
    end

    def disp(lines)
      lines.each{|line|
        if line.include?(',')
          show line
        else
          puts "    #{line}"
        end
      }
    end
    def show(line)
      puts "  #{line}"
    end

    def quit
      puts "\n終了操作quit"
      cont = ["c-x c-c, Quit emacs, ファイルを保存して終了",
              "c-z, suspend emacs,  一時停止，fgで復活"]
      disp(cont)
    end

    def window
      puts "\nウィンドウ操作window"
      cont=["c-x 2, 2 windows, 二つに分割",
            "c-x 1, 1 windows, 一つに戻す",
            "c-x 3, 3rd window sep,縦線分割",
            "c-x o, Other windows, 次の画面へ移動"]
      disp(cont)
    end

    def buffer
      puts "\nバッファー操作buffer"
      cont =[ "c-x b, show Buffer,   バッファのリスト",
              "c-x c-b, next Buffer, 次のバッファへ移動"]
      disp(cont)
    end

    def edit
      puts "\n編集操作editor"
      cont = ["c-d, Delete char, 一字削除",
              "c-k, Kill line,   一行抹消，カット",
              "c-y, Yank,        ペースト",
              "c-w, Kill region, 領域抹消，カット",
              "領域選択は，先頭or最後尾でc-spaceした後，最後尾or先頭へカーソル移動",
              "c-s, forward incremental Search WORD, 前へWORDを検索",
              "c-r, Reverse incremental search WORD, 後へWORDを検索",
              "M-x query-replace WORD1 <ret> WORD2：対話的置換(y or nで可否選択)"]
      disp(cont)
    end

    def file
      puts "\nファイル操作file"
      cont =[ "c-x c-f, Find file, ファイルを開く",
              "c-x c-s, Save file, ファイルを保存",
              "c-x c-w, Write file NAME, ファイルを別名で書き込む"]
      disp(cont)
    end

    def page_move
      puts "\nページ移動page"
      cont = ["c-v, move Vertical,          次のページへ",
              "M-v, move reversive Vertical,前のページへ",
              "c-l, centerise Line,       現在行を中心に",
              "M-<, move Top of file,    ファイルの先頭へ",
              "M->, move Bottom of file, ファイルの最後尾へ"]
      disp(cont)
    end

    def cursor_move
      puts "\nカーソル移動cursor"
      cont = ["c-f, move Forwrard,    前or右へ",
              "c-b, move Backwrard,   後or左へ",
              "c-a, go Ahead of line, 行頭へ",
              "c-e, go End of line,   行末へ",
              "c-n, move Next line,   次行へ",
              "c-p, move Previous line, 前行へ"]
      disp(cont)
    end

  end
end
