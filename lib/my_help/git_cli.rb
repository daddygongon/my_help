module MyHelp
  class Git < Thor
    desc "pull", "pull my helps"

    def pull
      puts "called my_help git pull"
      config = get_config(args)
      help_dir = config[:local_help_dir]
      puts "on the target git directory : %s" % help_dir
      Dir.chdir(help_dir) do
        system "git pull origin main"
      end
    end

    desc "push", "push my helps"

    def push
      puts "called my_help git push"
      config = get_config(args)
      help_dir = config[:local_help_dir]
      puts "on the target git directory : %s" % help_dir
      Dir.chdir(help_dir) do
        system "git add -A"
        system "git commit -m 'auto commit from my_help'"
        system "git pull origin main"
        system "git push origin main"
      end
    end
  end
end
