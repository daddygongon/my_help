

module MyHelp
  class CLI < Thor
    desc 'list [HELP] [ITEM]', 'list all helps, specific HELP, or ITEM'
    def list(*args)
      file = args[0]
      item = args[1]
      if file =~ /^\./
        puts MyHelpList.help_list(file)
        exit
      end
      invoke :setup
      if file.nil?
        puts $control.list_all.blue # list []
      elsif item.nil?
        begin
          puts $control.list_help(file) # list [file]
        rescue StandardError => e
          puts e.to_s.red
        end
      else
        begin
          puts $control.show_item(file, item) # list [file] [item]
        rescue StandardError => e
          puts e.to_s.red
        end
      end
    end
  end
end
