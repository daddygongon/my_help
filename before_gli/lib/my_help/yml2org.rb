# -*- coding: utf-8 -*-
require "yaml"

class YmlToOrg
  attr_accessor :contents

  def initialize(file)
    @contents = ''
    cont = ''
    if file.kind_of?(String)
      cont = YAML.load(File.read(file))
    elsif file.kind_of?(Hash)
      cont = file
    end
    yml_to_org(cont)
  end

  def plain_element(key, cont)
    @contents << cont[:cont].join("\n")+"\n" if cont.include?(:cont)
  end

  def yml_to_org(help_cont)
    pp help_cont
    @contents << "#+STARTUP: indent nolineimages\n" # nofold
    help_cont.each_pair do |key, cont|
      @contents << "* #{key.to_s}\n"
      plain_element(key, cont)
    end
  end
end

if __FILE__ == $0
  print YmlToOrg.new(ARGV[0]).contents
end
