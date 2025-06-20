require 'colorize'
module MyHelp
  class Init
    def initialize(config)
      @config = config
    end

    def help_dir_exist?
      if File.exist?(@config[:local_help_dir])
        raise "Local help dir exist.\n".red+
              "local help dir: #{@config[:local_help_dir]};
if you are sure, delete local help dir first.".green
      end
    end

    def check_conf_exist
      File.exist?(@config[:conf_file])
    end

    def mk_help_dir
      FileUtils.mkdir(@config[:local_help_dir])
    end

    def cp_templates
      target_dir = @config[:local_help_dir]
      src_dir = @config[:template_dir]
      ext = @config[:ext]
      Dir.glob(File.join(src_dir, "*#{ext}")).each do |file|
        FileUtils.cp(file, target_dir, verbose: false)
      end
    end
  end
end
