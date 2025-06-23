module MyHelp
  class Modify
    def initialize(conf)
      @conf = conf
      @ext = @conf[:ext]
    end

    def new(help_file)
      target = help_file
      source = File.join(@conf[:template_dir], "example.org")
      FileUtils.cp(source, target, verbose: @conf[:verbose])
    end

    def delete(help_file)
      if File.exist?(help_file)
        FileUtils.rm(help_file, verbose: @conf[:verbose])
      else
        puts "file #{help_file} does not exist."
      end
    end

    def edit(help_name)
      name = File.basename(help_name[0], @ext)
      path = File.exist?(name + @ext) ? name + @ext :
          File.join(@conf[:local_help_dir], name + @ext)
      if File.exist?(path)
        p comm = "#{@conf[:editor]} #{path}"
        system(comm)
      else
        puts "file #{path} does not exist,"
        puts "make #{help_name} first by 'new' command."
      end
    end
  end
end
