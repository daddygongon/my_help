# -*- coding: utf-8 -*-
require "optparse"
require "yaml"

class YmlToOrg
  attr_accessor :contents

  def initialize(file)
    @contents = ''
    case file
    when file.kind_of?(String)
      contents = YAML.load(File.read(file))
    when file.kind_of?(Hash)
      contents = file
    end
  end

  def head_and_licence(key, cont)
    cont.each { |line| @contents << "- #{line}\n" }
  end

  def plain_element(key, cont)
    cont[:cont].each { |line| @contents << "- #{line}\n" }
  end

  def yml_to_org(help_cont)
    @contents << "#+STARTUP: indent nolineimages\n" # nofold
    help_cont.each_pair do |key, cont|
      @contents << "* #{key.to_s}\n"
      if key == :head or key == :license
        head_and_licence(key, cont)
      else
        plain_element(key, cont)
      end
    end
  end
end

if __FILE__ == $0
  print YmlToOrg.new(ARGV[0]).contents
end
