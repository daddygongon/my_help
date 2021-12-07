

module MyHelp
  class CLI < Thor
    desc "list [HELP] [ITEM]",
    'list all helps, specific HELP, or ITEM'
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
          raise Error, e
        end
      else
        begin
          puts $control.show_item(file, item) # list [file] [item]
        rescue StandardError => e
          raise Error, e
        end
      end
    end
  end
end
