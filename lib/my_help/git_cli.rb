module MyHelp
  module GetConfig
    def get_config #(args)
      parent_help_dir = options["help_dir"] || ""
      parent_help_dir = ENV["HOME"] unless File.exist?(parent_help_dir)
      # Forget necessity of these 
      return Config.new(parent_help_dir)
    end
  end

  class Git < Thor
    include MyHelp::GetConfig

    desc "pull", "pull my helps"

    def pull
      puts "called my_help git pull"
      config = get_config
      help_dir = config[:local_help_dir]
      puts "on the target git directory : %s" % help_dir
      Dir.chdir(help_dir) do
        system "git pull origin main"
      end
    end

    desc "push", "push my helps"

    def push
      puts "called my_help git push"
      config = get_config
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
