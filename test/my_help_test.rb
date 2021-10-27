# -*- coding: utf-8 -*-
# frozen_string_literal: true

require "test_helper"
require "tmpdir"
require "fileutils"

class MyHelpTest < Test::Unit::TestCase
  include MyHelp

  test "VERSION" do
    assert do
      MyHelp.const_defined?(:VERSION)
    end
  end

  sub_test_case "List" do
    test "pwdはexample_dirへのpathを返す" do
      assert_block do
        p List.new.pwd
      end
    end
  end
end
