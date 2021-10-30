# -*- coding: utf-8 -*-
# frozen_string_literal: true

require "test_helper"
require "tmpdir"
require "fileutils"
#require_relative "my_help/lib/my_help/list"

class MyHelpTest < Test::Unit::TestCase
  include MyHelp

  test "VERSION" do
    assert do
      MyHelp.const_defined?(:VERSION)
    end
  end

  sub_test_case "List" do
    test "pwdはexample_dirへのpathを返す" do
      assert_equal(File.join(File.expand_path("../..", __FILE__), "example_dir"),
                   List.new.pwd("example_dir"))
    end

    test "lsはexample_dirのfileをArrayで返す" do
      dir = File.join(File.expand_path("../..", __FILE__), "example_dir", "*")
      assert_equal Dir.glob(dir), List.new.dir_glob("example_dir")
    end

    test "lsはexample_dirのfileを表示する" do
      assert do
        List.new.ls("example_dir")
      end
    end
  end
end
