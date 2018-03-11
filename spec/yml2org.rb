# -*- coding: utf-8 -*-
require "optparse"
require "yaml"

file = ARGV[0]
help_cont = YAML.load(File.read(file))
print "#+STARTUP: indent nolineimages nofold\n"
help_cont.each_pair do |key, cont|
  p key
  p cont
  unless key == :head
    print "* #{cont[:title]}\n"
    cont[:cont].each do |line|
      print "** #{line}\n"
    end
  end
end
