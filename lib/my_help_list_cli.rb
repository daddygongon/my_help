

module MyHelp
  class CLI < Thor
    desc "list [HELP] [ITEM] -d=\'./test\'",
    'list all helps, specific HELP, or ITEM with target dir'
    def list(*args)
      invoke :setup

      file = args[0]
      item = args[1]
      if file =~ /^\./ # if file='./README.org', output it
        if item.nil?
          puts MyHelpList.help_list(file)
        else
          puts MyHelpList.item_list(file, item)
        end
        return #exit
      end
      if file.nil?
        puts $control.list_all # list []
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
