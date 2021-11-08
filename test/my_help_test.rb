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
       assert_equal expected, Control.new.list_all
      #end

    expected = <<~EXPECTED  
 - ruby
      , head           : head
      , license        : license
    -p, puts_%         : puts_%
   EXPECTED
    assert_equal expected, Control.new.list_help('ruby')

    expected = <<~EXPECTED
- my todo
-----

- ご飯を食べる
- 10時には寝床へ入る
EXPECTED

    assert_equal expected, Control.new.show_item('todo','-d')
    end
  end
end
