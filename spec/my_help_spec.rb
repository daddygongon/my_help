# -*- coding: utf-8 -*-
require 'spec_helper'
require 'command_line/global'

clear  = CE.fg(:blue).get("Clear")
miss =   CE.fg(:red).get("Miss")
local_help_dir = File.join(ENV['HOME'],'.my_help')


describe '#list' do
  context 'exist file' do
    test_list = command_line('my_help','list','sample')
    p test_list
    it 'exitstatus test' do
      if test_list.exitstatus ==  0
        puts clear
      else
        puts miss
      end
    end

    it 'stdout test' do
      if test_list.stdout == "- ヘルプのサンプル雛形\n-   headに常に表示される内容を記述\n     , head           : head\n     , license        : license\n   -i, item_example   : item_example\n"
        puts clear
      else
        puts miss
      end
    end


    it 'stderr test' do
      if test_list.stderr == ""
        puts clear
      else
        puts miss
      end
    end
  end

  context 'not exist file' do
    test_list_a = command_line('my_help','list','sample_list_test')
    p test_list_a
    it 'exitstatus test' do
      if test_list_a.exitstatus ==  1
        puts clear
      else
        puts miss
      end
    end


    it 'stdout test' do
      if test_list_a.stdout == ""
        puts clear
      else
        puts miss
      end
    end


    it 'stderr test' do
      if test_list_a.stderr == "error: No such file or directory @ rb_sysopen - "+ local_help_dir + "/sample_list_test.org\n"
        puts clear
      else
        puts miss
      end
    end
  end
end

