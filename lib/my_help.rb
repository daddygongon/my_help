# -*- coding: utf-8 -*-
require "thor"
require "command_line/global"
require "colorize"

require "my_help_list_cli"
require "my_help/my_help_list"
require "my_help/version"
require "my_help/my_help_controll"
require "my_help/tomo_help_controll"
require "my_help/org2yml"
# Add requires for other files you add to your project here, so
# you just need to require this one file in your bin file

module MyHelp
  class CLI < Thor
    desc("setup", "set up the test database")

    def setup(*args)
      puts "my_help called with '%s'" % args.join(" ")
      $control = Control.new
    end

    desc "version", "show version"

    def version
      #invoke :setup
      puts VERSION
    end

    desc "set_editor EDITOR_NAME", "set editor to EDITOR_NAME"

    def set_editor(editor_name)
      invoke :setup
      $control.set_editor(editor_name)
    end

    desc "edit HELP", "edit HELP"

    def edit(help_name)
      invoke :setup
      $control.edit_help(help_name)
    end

    desc "new HELP", "make new HELP"

    def new(help_name)
      invoke :setup
      $control.init_help(help_name)
    end

    desc "delete HELP", "delete HELP"

    def delete(help_name)
      invoke :setup
      $control.delete_help(help_name)
    end

    desc "git [push|pull]", "git push or pull"

    def git(push_or_pull, *args)
      p push_or_pull
      invoke :setup
      argument_size = args.size
      Dir.chdir($control.local_help_dir) do
        case push_or_pull
        when "push"
          if argument_size == 0
            comms = ["git add -A",
                     "git commit -m 'git push from my_help'",
                     "git push origin main"]
          else
            p args
            argument_size.times do |i|
              orgfile = args[i] + ".org"
              file = File.join($control.local_help_dir, orgfile)
              if File.exist?(file) == true
                puts orgfile.green
                dir = $control.local_help_dir
                Dir.chdir(dir) do
                  comm = "git add " + file
                  puts c
                  c = command_line(comm)
                  puts c.stdout.blue
                  puts c.stderr.red
                end
              else
                puts (orgfile + " does not existed").red
              end
            end
            comms = ["git commit -m 'git push from my_help'",
                     "git push origin main"]
          end
        when "pull"
          comms = ["git pull"]
        else
          raise "my_help git was called by the other than 'push or pull'"
        end
        comms.each do |comm|
          puts comm
          c = command_line(comm)
          puts c.stdout.blue
          puts c.stderr.red
        end
      end
    end

    #  desc "search {find_char}", "search FIND_CHAR"
    #  def search(find_char)
    #    invoke :setup
    #    $control.search_help(find_char)
    #  end
  end
end
