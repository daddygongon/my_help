# coding: utf-8
# frozen_string_literal: true

require "test_helper"
require "tmpdir"
require "fileutils"

class MyHelpTest < Test::Unit::TestCase
  include MyHelp

  sub_test_case "Misc" do
    test "VERSION" do
      assert do
        MyHelp.const_defined?(:VERSION)
      end
    end
  end

  sub_test_case "Config" do
    test "initialize" do
      assert do
        p Config.new(File.join(Dir.pwd,'test')).config
      end
    end
  end

  sub_test_case "List" do
    test "List all" do
      expected = <<~EXPECTED

List all helps
      ruby: - ruby
       org: - emacs org-modeのhelp
      todo: - my todo
my_help_test: - my_help_test
     emacs: - Emacs key bind
  new_help: - ヘルプのサンプル雛形
  EXPECTED
  #assert_block do
      conf_path = File.join(Dir.pwd,'test')
      assert_equal expected, Control.new(conf_path).list_all

    end

    test "List 'ruby'" do
    expected = <<~EXPECTED
 - ruby
      , head           : head
      , license        : license
    -p, puts_%         : puts_%
   EXPECTED
      conf_path = File.join(Dir.pwd,'test')
      assert_equal expected, Control.new(conf_path).list_help('ruby')
    end
  end
end
