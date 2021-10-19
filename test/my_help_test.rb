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
  test "Config" do
    assert do
      MyHelp::Config.new()
    end
  end
end
