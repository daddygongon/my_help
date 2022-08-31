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
      conf_path = File.join(Dir.pwd, "test")
      expected = { :template_dir => File.expand_path("../lib/templates", conf_path),
                   local_help_dir: File.join(conf_path, ".my_help"),
                   conf_file: File.join(conf_path, ".my_help/.my_help_conf.yml"),
                   :editor => "emacs" }
      assert_equal expected, Config.new(conf_path).config
    end
  end

  sub_test_case "List" do
    test "List all" do
      expected = /List all helps/
      #assert_block do
      conf_path = File.join(Dir.pwd, "test")
      assert_match expected, Control.new(conf_path).list_all
    end

    test "List 'ruby' returns RuntimeError" do
      conf_path = File.join(Dir.pwd, "test")
      assert_raise WrongFileName do
        Control.new(conf_path).list_help("ruby")
      end
    end

    test "List 'todo','-d'" do
      expected = /^- my todo/ # これが適切かどうか．．
      conf_path = File.join(Dir.pwd, "test")
      assert_match expected, Control.new(conf_path).show_item("todo", "-d")
      # assert_matchでRegExpとの比較をとっています．
      # assert_equal true, /^Hello, .*!$/ === hello
      # なんかでもいけますが，見にくいのでassert_matchを使います．
      # ただ，正規のmanualには見当たらなく．．．探して．
      # https://www.rubydoc.info/github/test-unit/test-unit/Test/Unit/Assertions
my_      # こっちが良さそう．
      # あった．
      # https://ruby-doc.org/stdlib-3.0.0/libdoc/test-unit/rdoc/Test/Unit/Assertions.html#method-i-assert_match
    end
  end
end
