# -*- coding: utf-8 -*-
require './test_helper'
require 'my_help'
require 'colorize'
class TestMyHelpControl <  Test::Unit::TestCase
  def setup
    @control = MyHelp::Control.new()
    @control.local_help_dir  = './my_help_sample_dir'
    @conf_file = File.join(Dir.pwd,'.my_help_conf.yml')
  end

=begin
  require 'yaml'
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
  must "show local help dir" do
    assert_equal('./my_help_sample_dir',@control.local_help_dir)
  end
  # must "list all" do
  def test_list_all
    puts expected = "\nList all helps\nhelp_template: - ヘルプのサンプル雛形\n"
    assert_equal(expected, @control.list_all)
  end
  #must "raise error on list_help with wrong help name" do
  def test_list_help_with_wrong_help
    e = assert_raises MyHelp::Control::WrongFileName do
      @control.list_help('wrong_file')
    end
    puts e.to_s.red
  end
  #must "list items with correct help name" do
  def test_list_help_with_correct_help
      assert_nothing_raised do
      @control.list_help('help_template')
    end
  end
  # must "raise error on show_item with wrong item" do
  def test_show_item_with_wrong_item
      e = assert_raises MyHelp::Control::WrongItemName do
      @control.show_item('help_template', 'wrong_item')
    end
    assert_equal("No item entry: wrong_item",  e.to_s)
  end
  #must "show items with correct long item"
  def test_show_item_with_correct_long_item
    assert_nothing_raised do
      @control.show_item('help_template', 'item_example')
    end
  end
  #must "show items with correct short item"
  def test_show_item_correct_short_item_short
    assert_nothing_raised do
      @control.show_item('help_template', '-i')
    end
  end
  #must "change editor"
  def test_change_editor
    tmp_editor = @control.editor
    @control.set_editor('vim')
    assert_equal('vim', @control.editor)
    @control.editor=tmp_editor
#    @control.edit_help('help_template')  # => command_line(rspec)でassertするべき
  end

end


