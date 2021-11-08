require "fileutils"
require "colorize"

module MyHelp
  # Push from file in cwd to target_dir
  class Push
    def initialize(path)
      @path = path
    end

    def push(cp_source)
      FileUtils.mkdir_p(File.expand_path("..", @cp_target))
      FileUtils.cp(cp_source, @cp_target, verbose: true)
    end

    def check_diff(cp_source)
      @cp_target = File.join(@root_dir, cp_source)
raise "push is only executable for a file. Use \'dir/*\'." if File.directory?(cp_source)
      puts "Checking #{cp_source} and #{@root_dir}...".green
      if File.exist?(@cp_target)
        show_diff(@cp_target, cp_source)
      else
        "#{cp_source} does not exist in #{@root_dir}"
      end
    end

    def show_diff(cp_target, cp_source)
      res = command_line "diff #{cp_target} #{cp_source}"
      if res.stdout == ""
        "No diff between #{cp_source} and #{cp_target}"
      else
        puts_diff(res.stdout)
      end
    end

    def puts_diff(diff_text)
      diff_text.split("\n")[0..20].collect do |line|
        case line[0]
        when ">" then "here:#{line}".on_light_cyan
        when "<" then "there:#{line}".on_light_white
        else line
        end
      end.join("\n")
    end
  end
end
