# coding: utf-8
# frozen_string_literal: true

require "test_helper"
require "tmpdir"
require "fileutils"

class MyHelpTest < Test::Unit::TestCase
  include MyHelp
  sub_test_case "Version" do
    test "show version" do
      expected = "1.0b"
      assert_equal expected, VERSION
    end
  end

  sub_test_case "Set Editor" do
    test "set_editor" do
      expected = "set editor 'emacs'"
      conf_path = File.join(Dir.pwd, "test")
      assert_equal expected, Control.new(conf_path).set_editor("emacs")
    end
  end
end
