require 'yaml'
require 'colorize'

module MyHelp
  # Configuration defaults
  @config = {
    :template_dir => File.expand_path("../../templates", __FILE__),
    :local_help_dir => File.join(@conf_path, '.my_help'),
    :conf_file => File.join(@conf_path, '.my_help', '.my_help_conf.yml')
    :editor => ENV['EDITOR'] || 'emacs'
  }

  @valid_config_keys = @config.keys

  # Configure through hash
  def self.configure(opts = {})
    opts.each {|k,v| @config[k.to_sym] = v if @valid_config_keys.include? k.to_sym}
  end

  # Configure through yaml file
  def self.configure_with(path_to_yaml_file)
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
