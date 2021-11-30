# frozen_string_literal: true

require "yaml"
require "colorize"

module MyHelp
  # make @config from default and load yaml
  # as shown https://stackoverflow.com/questions/6233124/where-to-place-access-config-file-in-gem
  class Config
    # Configuration defaults
    def initialize(conf_path = nil)
      @conf_path = conf_path || ENV["HOME"]
      @config = {
        template_dir: File.expand_path("../templates", __dir__),
        local_help_dir: File.join(@conf_path, ".my_help"),
        conf_file: File.join(@conf_path, ".my_help", ".my_help_conf.yml"),
        editor: ENV["EDITOR"] || "emacs",
      }
      @valid_config_keys = @config.keys
      configure_with(@config[:conf_file])
    end

    # Configure through hash
    def configure(opts = {})
      opts.each do |k, v|
        @config[k.to_sym] = v if @valid_config_keys.include? k.to_sym
      end
    end

    # Configure through yaml file
    def configure_with(path_to_yaml_file)
      begin
        config = YAML.safe_load(IO.read(path_to_yaml_file),
                                permitted_classes: [Symbol])
      rescue Errno::ENOENT
        # log(:warning, "YAML configuration file couldn't be found. Using defaults.")
        puts 'YAML configuration file couldn\'t be found. Using defaults.'.red
        return
      rescue Psych::SyntaxError
        # log(:warning, "YAML configuration file contains invalid syntax. Using defaults.")
        puts "YAML configuration file contains invalid syntax. Using defaults.".red
        return
      end

      configure(config)
    end

    attr_reader :config
  end
end
