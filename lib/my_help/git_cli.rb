module MyHelp
  class Git < Thor
    desc "pull", "pull my helps"

    def pull
      config = get_config(args)
      puts "called my_help git pull"
      help_dir = config.config[:local_help_dir]
      Dir.chdir(help_dir) do
        system "git pull origin main"
      end
    end

    desc "push", "push my helps"

    def push
      config = get_config(args)
      puts "called my_help git push"
      help_dir = config.config[:local_help_dir]
      Dir.chdir(help_dir) do
        system "git add -A"
        system "git commit -m 'auto commit from my_help'"
        system "git pull"
        system "git push"
      end
    end

    no_commands {
      def get_config(args)
        # RSpec環境と，実動環境の差をここで吸収
        # RSpecではargsの最後にtemp_dirをつけているから
        args[0] = "" if args.size == 0
        help_dir = args[-1]
        help_dir = ENV["HOME"] unless File.exist?(help_dir)
        return Config.new(help_dir)
      end
    }
  end
end
