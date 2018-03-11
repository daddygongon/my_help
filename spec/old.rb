# -*- coding: utf-8 -*-
require "yaml"
require "pp"

class OrgToYaml
  attr_accessor :help_cont

  def initialize(file)
    @help_cont = {:head => File.basename(file,'.org')}
    @cont_sym = nil
    @conts = ""
    org_to_yaml(File.readlines(file))
  end

  def make_options(line)
    head, desc = line.split(':')
    desc = desc || head
    {:short=>"-#{head[0]}", :long=>"--#{head}", :desc=>"#{desc}"}
  end

  def next_cont(head)
    @help_cont[@cont_sym][:cont] = @conts if @cont_sym
    @conts = ""
    @cont_sym = head.to_sym
    @help_cont[@cont_sym] = {
      :opts=> make_options(head),:title=>head, :cont=> ""
    }
  end

  def org_to_yaml(lines)
    lines.each do |line|
      if m = line.match(/^\* (.+)/)
        next_cont m[1]
      else
        @conts << line
      end
    end
  end
end

helps = OrgToYaml.new(ARGV[0])
pp helps.help_cont
