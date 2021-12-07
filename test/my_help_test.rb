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
      # こっちが良さそう．
      # あった．
      # https://ruby-doc.org/stdlib-3.0.0/libdoc/test-unit/rdoc/Test/Unit/Assertions.html#method-i-assert_match
    end
  end

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

  sub_test_case "Edit Help" do
    test "edit_help" do
      puts "
システムコールが呼ばれているのでテストできません．
edit_helpでは，thorでmy_help_test.orgなどが呼ばれたときに，
呼ばれるものです．
そうするとtarget_helpにいき，それがlocal_help_entries.memberかを見て，
memberの時にはシステムコールされます．
ところがこれをtestすることはできない為，今は先送りしています．
Arubaで試すべきでしょう．
"
      # expected = target_help
      # conf_path = File.join(Dir.pwd, "test")
      # assert_equal expected, Control.new(conf_path).edit_help("my_help_test")
    end
  end

  sub_test_case "Local Help Entries" do
    test "init_help with my_help_test" do
      puts "
init_helpという名前はよくないですね．
new_helpに変えてきましょう．
"
      conf_path = File.join(Dir.pwd, "test")
      puts Control.new(conf_path).init_help("my_help_test")
    end
    test "init_help without argument(引数)" do
      conf_path = File.join(Dir.pwd, "test")
      assert_raise_with_message(Error, "Specify NAME") do
        Control.new(conf_path).init_help()
      end
      # Errorを吐くように変更．
      # それに合わせてassert_raise_with_messageでのテストに書き換えてみました．
      # init_help with my_help_testを書き換えてみて下さい．
    end
    test "edit_help" do
      conf_path = File.join(Dir.pwd, "test")
      #      puts Control.new(conf_path).edit_help("my_help_test")
    end
  end
end
