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
end
