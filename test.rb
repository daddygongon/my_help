require 'yaml'
require 'pp'

pp YAML.load(File.read(ARGV[0]))
