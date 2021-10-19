require 'yaml'
require 'colorize'

module MyHelp
  class Config
  # Configuration defaults
    def initialize(conf_path=nil)
      @conf_path = conf_path || ENV['HOME']
      @config = {
        :template_dir => File.expand_path("../../templates", __FILE__),
        :local_help_dir => File.join(@conf_path, '.my_help'),
        :conf_file => File.join(@conf_path, '.my_help', '.my_help_conf.yml'),
        :editor => ENV['EDITOR'] || 'emacs'
      }
      @valid_config_keys = @config.keys
      configure_with(@config[:conf_file])
      p @config
      return @config
    end


    #
    #
    # Configure through hash
    def configure(opts = {})
      opts.each do |k,v|
        if @valid_config_keys.include? k.to_sym
          @config[k.to_sym] = v
        end
      end
    end

    # Configure through yaml file
    def configure_with(path_to_yaml_file)
      begin
        config = YAML::load(IO.read(path_to_yaml_file))
      rescue Errno::ENOENT
        # log(:warning, "YAML configuration file couldn't be found. Using defaults.")
        puts "YAML configuration file couldn't be found. Using defaults.".red
        return
      rescue Psych::SyntaxError
        # log(:warning, "YAML configuration file contains invalid syntax. Using defaults.")
        puts "YAML configuration file contains invalid syntax. Using defaults.".red
        return
      end

      configure(config)
    end

    def self.config
      @config
    end
  end
end
