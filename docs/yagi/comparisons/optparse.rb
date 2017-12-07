#!/usr/bin/ruby
require 'optparse'

options = {:name => nil}

parser = OptionParser.new do|opts|
  opts.on('-n', '--name name', 'Give your own name') do |name|
    options[:name] = name;
    end

  opts.on('-h', '--help', 'Displays Help') do
    puts opts
    exit
    end
end

parser.parse!

sayHello = 'Hello ' + options[:name]

puts sayHello
