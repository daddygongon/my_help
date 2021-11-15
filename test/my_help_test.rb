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
      expected = <<~EXPECTED

        List all helps
               org: - emacs org-modeのhelp
              todo: - my todo
             emacs: - Emacs key bind
      EXPECTED
      #assert_block do
      conf_path = File.join(Dir.pwd, "test")
      assert_equal expected, Control.new(conf_path).list_all
    end

    test "List 'ruby' returns RuntimeError" do
      conf_path = File.join(Dir.pwd, "test")
      assert_raise WrongFileName do
        Control.new(conf_path).list_help("ruby")
      end
    end

    test "List 'todo','-d'" do
      expected = <<~EXPECTED
        - my todo
        -----
        \e[0;32;49mdaily\e[0m
        - ご飯を食べる
        - 10時には寝床へ入る
      EXPECTED
      conf_path = File.join(Dir.pwd, "test")
      assert_equal expected, Control.new(conf_path).show_item("todo", "-d")
    end
  end
end
