# -*- coding: utf-8 -*-
require 'test/unit'
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'my_help'

class TestMyHelp <  Test::Unit::TestCase
  def setup
    @control = MyHelp::Control.new()
    @control.local_help_dir  = './my_help_sample_dir'
  end
  def test_local_help_dir
    p @control
    assert_equal('./my_help_sample_dir',@control.local_help_dir)
  end
  def test_list_no_args
    puts expected = "\e[0;34;49mList all helps\n" +
"\e[0m\e[0;34;49mhelp_template\e[0m\e[0;34;49m: - ヘルプのサンプル雛形\n" +
"\e[0m"
    assert_equal(expected, @control.list_all)
  end
end

