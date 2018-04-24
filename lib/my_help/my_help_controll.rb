module MyHelp
  class Control
    def initialize(argv)
      @argv = argv
      @template_dir = File.expand_path("../../templates", __FILE__)
      @exe_dir = File.expand_path("../../exe", __FILE__)
      @local_help_dir = File.join(ENV['HOME'],'.my_help')
      @system_inst_dir = RbConfig::CONFIG['bindir']
      set_help_dir_if_not_exists
    end

    def set_help_dir_if_not_exists
      return if File::exists?(@local_help_dir)
      FileUtils.mkdir_p(@local_help_dir, :verbose=>true)
      Dir.entries(@template_dir).each{|file|
        next if file=='template_help.org'
        file_path=File.join(@local_help_dir,file)
        next if File::exists?(file_path)
        FileUtils.cp((File.join(@template_dir,file)),@local_help_dir,:verbose=>true)
      }
    end

    def show(file, item)
      file_path=File.join(@local_help_dir,file+'.org')
      help = auto_load(file_path)
      print help[:head][:cont]
      print '-'*5+"\n"
      print item.red+"\n"
      print help[item.to_sym][:cont]
    end

    def list_helps(file)
      if file.nil?
        list_all
      else
        list_help(file)
      end
    end

    def list_help(file)
      file_path=File.join(@local_help_dir,file+'.org')
      help = auto_load(file_path)
      help.each_pair do |key, conts|
        print conts[:cont] if key==:head
        disp_opts( conts[:opts] )
      end
    end

    def disp_opts( conts )
      col = 0
      conts.each_pair do |key, item|
        col_length = case col
                     when 0; print item.rjust(5)+", "
                     when 1; print item.ljust(15)+": "
                     else; print item
                     end
        col += 1
      end
      print("\n")
    end

    def list_all
      print "List all helps\n"
      local_help_entries.each do |file|
        file_path=File.join(@local_help_dir,file)
        title = file.split('.')[0]
        help = auto_load(file_path)
        next if help.nil?
        desc = help[:head][:cont].split("\n")[0]
        print "  #{title}\t: #{desc}\n".blue
      end
    end

    def edit_help(file)
      target_help = File.join(@local_help_dir,file)
      ['.yml','.org'].each do |ext|
        p target_help += ext if local_help_entries.member?(file+ext)
      end
      system "emacs #{target_help}"
    end

    def init_help(file)
      p target_help=File.join(@local_help_dir,file+'.org')
      if File::exists?(target_help)
        puts "File exists. --delete it first to initialize it."
        exit
      end
      p template = File.join(@template_dir,'template_help.org')
      FileUtils::Verbose.cp(template,target_help)
    end

    def delete_help(file)
      file = File.join(@local_help_dir,file+'.org')
      print "Are you sure to delete "+file.blue+"?[Ynq] ".red
      case gets.chomp
      when 'Y'
        begin
          FileUtils.rm(file,:verbose=>true)
        rescue => error
          puts error.to_s.red
        end
      when 'n', 'q' ; exit
      end
    end

    private
    def local_help_entries
      entries= []
      Dir.entries(@local_help_dir).each{|file|
        next unless file.include?('_')
        next if file[0]=='#' or file[-1]=='~' or file[0]=='.'
        next if file.match(/(.+)_e\.org/) # OK?
        next if file.match(/(.+)\.html/)
        entries << file
      }
      return entries
    end

    def auto_load(file_path)
      case File.extname(file_path)
      when '.yml'
        cont = YAML.load(File.read(file_path))
      when '.org'
        cont = OrgToYaml.new(file_path).help_cont
      else
        puts "Not handling file types of #{file_path}"
        cont = nil
      end
      cont
    end


  end
end
