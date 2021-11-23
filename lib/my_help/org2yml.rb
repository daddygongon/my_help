# -*- coding: utf-8 -*-
require 'yaml'
require 'pp'

class OrgToYaml
  attr_accessor :help_cont

  def initialize(file)
    @help_cont = {} #{ head: [File.basename(file, '.org')] }
    @head_sym = nil
    @conts = ''
    @short_stored = []
    org_to_yaml(File.readlines(file))
  end

  def make_options(line)
    head, desc = line.split(':')
    desc ||= head.to_s
    short = "-#{head[0]}"
    if @short_stored.include?(short) or head=='license' or head=='head'
      short = ''
    else
      @short_stored << short
    end
    { short: short, long: "#{head}", desc: desc }
  end

  def next_cont(head)
    @help_cont[@head_sym][:cont] = @conts if @head_sym
    return if head == 'EOF'
    @conts = ''
    @head_sym = head.to_sym
    @help_cont[@head_sym] = {
      opts: make_options(head), title: head, cont: ''
    }
  end

  def org_to_yaml(lines)
    lines.each do |line|
      m = line.force_encoding(Encoding::UTF_8).match(/^(\*+) (.+)/u)
      if m
        next_cont m[2]
      else
        @conts << line
      end
    end
    next_cont 'EOF'
  end
end

if $PROGRAM_NAME == __FILE__ 
  helps = OrgToYaml.new(ARGV[0])
  pp helps.help_cont
end
