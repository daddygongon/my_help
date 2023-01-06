module MyHelp

  # make @config from default and load yaml
  # as shown
  # https://stackoverflow.com/questions/6233124/where-to-place-access-config-file-in-gem
  class Config
    attr_reader :valid_config_keys
    # Configuration defaults
    def initialize(conf_path = nil)
      conf_path ||= ENV["HOME"]
      local_help_dir = File.join(conf_path, ".my_help")
      @config = {
        template_dir: File.expand_path("../templates", __dir__),
        local_help_dir: local_help_dir,
        conf_file: File.join(local_help_dir, ".my_help_conf.yml"),
        editor: ENV["EDITOR"] || "emacs",
        ext: ".org",
        verbose: false,
      }
      @valid_config_keys = @config.keys
      configure_with(@config[:conf_file])
      #      YAML.dump(@config, File.open(@config[:conf_file], 'w'))
      # no good for multiple testers.
    end

    # Configure through hash
    def configure(opts = nil)
      return if opts == nil
      opts.each do |k, v|
        if @valid_config_keys.include? k.to_sym
          @config[k.to_sym] = v
        elsif k == "".to_sym
          print "Valid key words are follows:"
          p @valid_config_keys
        else
          raise KeyError.new("Error: keyword '#{k}' is invalid",
                             receiver: @config,
                             key: k)
        end
      end
      @config
    end

    # Configure through yaml file
    def configure_with(path)
      begin
        config = YAML.safe_load(IO.read(path),
                                permitted_classes: [Symbol])
      rescue Errno::ENOENT => e
        message = "WARNING: #{e.message}.\nUsing default conf."
        $stderr.puts message if @config[:verbose]
      rescue Psych::SyntaxError => e
        message = "WARNING: #{e.message}.\nUsing default conf."
        $stderr.puts message if @config[:verbose]
      end
      configure(config)
    end

    # save config in  @config[:conf_file]
    def save_config()
      File.write(@config[:conf_file], YAML.dump(config))
    end

    attr_reader :config

    def [](sym)
      @config[sym]
    end
  end
end
