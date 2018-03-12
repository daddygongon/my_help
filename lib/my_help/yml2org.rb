# -*- coding: utf-8 -*-
require "optparse"
require "yaml"

class YmlToOrg
  def initialize(file)
    yml_to_org(YAML.load(File.read(file)))
  end

  def head_and_licence(key, cont)
    print "* #{key.to_s}\n"
    cont.each do |line|
      print "- #{line}\n"
    end
  end

  def plain_element(key, cont)
    print "* #{cont[:title]}\n"
    cont[:cont].each do |line|
      print "- #{line}\n"
    end
  end

  def yml_to_org(help_cont)
    print "#+STARTUP: indent nolineimages\n" # nofold
    help_cont.each_pair do |key, cont|
      if key == :head or key == :license
        head_and_licence(key, cont)
      else
        plain_element(key, cont)
      end
    end
  end
end

if __FILE__ == $0
  YmlToOrg.new(ARGV[0])
end
