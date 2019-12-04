# -*- coding: utf-8 -*-
require './test_helper'
require 'my_help'

class TestMyHelpControl <  Test::Unit::TestCase
  def setup
    @control = MyHelp::Control.new()
    @control.local_help_dir  = './my_help_sample_dir'
    @conf_file = File.join(Dir.pwd,'.my_help_conf.yml')
  end

  require 'yaml'
=begin
  def test_set_conf
    @control.set_conf('emacs')
    assert_equal('emacs', @control.editor)
  end

  def test_load_conf
    file_name = '.my_help_conf.yml'
    @conf_file = File.join(Dir.pwd, file_name)
    conf = {:editor => 'vim'}
    file = File.open(@conf_file, 'w')
    YAML.dump(conf, file)
    file.close
    @control.load_conf # yaml
    assert_equal('vim', @control.editor)
  end
=end
#  def test_assert
  must "be assert" do
    assert { @control.is_a?(MyHelp::Control) }
  end
  must "test local help dir" do
    assert_equal('./my_help_sample_dir',@control.local_help_dir)
  end
  def test_list_no_args
    puts expected = "\e[0;34;49mList all helps\n" +
"\e[0m\e[0;34;49mhelp_template\e[0m\e[0;34;49m: - ヘルプのサンプル雛形\n" +
"\e[0m"
    assert_equal(expected, @control.list_all)
  end
  def test_list_wrong_file
    e = assert_raises MyHelp::Control::WrongFileName do
      @control.list_help('wrong_file')
    end
    puts e
  end
  def test_list_correct_file
    assert_nothing_raised do
      @control.list_help('help_template')
    end
  end
  def test_list_wrong_item
    e = assert_raises MyHelp::Control::WrongItemName do
      @control.show_item('help_template', 'wrong_item')
    end
    puts e
  end
  def test_list_correct_long_item
    assert_nothing_raised do
      @control.show_item('help_template', 'item_example')
    end
  end
  def test_list_correct_short_item_short
    assert_nothing_raised do
      @control.show_item('help_template', '-i')
    end
  end
  def test_change_editor
    @control.editor = 'vim'
    assert_equal('vim', @control.editor)
#    @control.edit_help('help_template')  # => command_line(rspec)でassertするべき
  end

end


