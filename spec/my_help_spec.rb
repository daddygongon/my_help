# -*- coding: utf-8 -*-
require 'spec_helper'
require 'command_line/global'

clear  = CE.fg(:blue).get("Clear")
miss =   CE.fg(:red).get("Miss")
local_help_dir = File.join(ENV['HOME'],'.my_help')


describe '#list' do

  context 'my_help list exist file' do
    test_list = command_line('my_help','list','sample')
    it 'exitstatus test' do
      if test_list.exitstatus ==  0
        puts clear
      else
        puts miss
      end
    end

    it 'stdout test' do
      message = <<'EOS'
- ヘルプのサンプル雛形
-   headに常に表示される内容を記述
     , head           : head
     , license        : license
   -i, item_example   : item_example
EOS
      if test_list.stdout == message
        puts clear
      else
        puts miss
      end
    end


    it 'stderr test' do
      if test_list.stderr == ""
        puts clear
      else
        puts miss
      end
    end
  end

  context 'my_help_list not exist file' do
    test_list_a = command_line('exe/my_help_gli','list','sample_list_test')

    it 'exitstatus test' do
      if test_list_a.exitstatus ==  1
        puts clear
      else
        puts miss
        puts "存在しないファイルをlistした時 exit_statusは1になるはず．"
      end
    end


    it 'stdout test' do
      if test_list_a.stdout == ""
        puts clear
      else
        puts miss
      end
    end


    it 'stderr test' do
      if test_list_a.stderr == "error: No help named 'sample_list_test' in the directory '" + local_help_dir + "'.\n"
        puts clear
      else
        puts miss
      end
    end
  end
end


describe '#edit' do
  context'my_help edit' do
  test_edit = command_line('my_help','edit')

    it 'exitstatus test' do
      if test_edit.exitstatus == 1
        puts clear
      else
        puts miss
        puts "fileを指定していないのでエラーが出るのに対し，exitstatusが正常値の0で終了している．"
      end
    end

    it 'stdout test' do
      if test_edit.stdout == ""
        puts clear
      else
        puts miss
      end
    end

    it 'stderr test' do
      if test_edit.stderr == "ERROR: \"my_help edit\" was called with no arguments\nUsage: \"my_help edit HELP\"\nDeprecation warning: Thor exit with status 0 on errors. To keep this behavior, you must define `exit_on_failure?` in `MyCLI`\nYou can silence deprecations warning by setting the environment variable THOR_SILENCE_DEPRECATION.\n"
        puts clear
      else
        puts miss
      end
    end
  end

  context'my_help edit exist file' do
    test_edit_a = command_line('my_help','edit','sample')

    it 'exitstatus test' do
      if test_edit_a.exitstatus == 0
        puts clear
      else
        puts miss
      end
    end

     it 'stdout test' do
      if test_edit_a.stdout == "\"" +local_help_dir + "/sample.org\"\n"
        puts clear
      else
        puts miss
      end
    end

    it 'stderr test' do
      if test_edit_a.stderr == ""
        puts clear
      else
        puts miss
      end
    end
  end

  context'my_help edit not exist file' do
    test_edit_b = command_line('my_help','edit','sample_edit')

    it 'exitstatus test' do
      if test_edit_b.exitstatus == 1
        puts clear
      else
        puts miss
        puts "存在していないfileをeditするとエラーがでるのに対し，exitstatusが正常値の0で終了している"
      end
    end

    it 'stdout test' do
      if test_edit_b.stdout == "\"" + local_help_dir + "/sample_edit.org\"\nfile " + local_help_dir + "/sample_edit.org does not exits in " + local_help_dir + ".\ninit sample_edit first.\n"
        puts clear
      else
        puts miss
      end
    end

    it 'stderr test' do
      if test_edit_b.stderr == ""
        puts clear
      else
        puts miss
      end
    end
  end
end

describe '#new' do
  context'my_help new' do
    test_new = command_line('my_help','new')

    it 'exitstatus test' do
      if test_new.exitstatus == 1
        puts clear
      else
        puts miss
        puts "作成するfile名を指定していないのでエラーが出るのに対し，exitstatusが正常値の0で終了している．"
      end
    end

    it 'stdout test' do
      if test_new.stdout == ""
        puts clear
      else
        puts miss
      end
    end


    it 'stderr test' do
      if test_new.stderr == "ERROR: \"my_help new\" was called with no arguments\nUsage: \"my_help new HELP\"\nDeprecation warning: Thor exit with status 0 on errors. To keep this behavior, you must define `exit_on_failure?` in `MyCLI`\nYou can silence deprecations warning by setting the environment variable THOR_SILENCE_DEPRECATION.\n"
        puts clear
      else
        puts miss
      end
    end
  end

  context'my_help new file' do
    test_new_file = command_line('my_help','new','sample_new')

    it 'exitstatus test' do
      if test_new_file.exitstatus == 0
        puts clear
      else
        puts miss
      end
    end

# stdout,errの中身変える
    it 'stdout test' do
      if test_new_file.stdout == "\"/Users/Shuhei/.my_help/sample_new.org\"\n\"/Users/Shuhei/.rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/gems/my_help-0.8.5/lib/templates/help_template.org\"\n"
        puts clear
      else
        puts miss
      end
    end


    it 'stderr test' do
      if test_new_file.stderr == "cp /Users/Shuhei/.rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/gems/my_help-0.8.5/lib/templates/help_template.org /Users/Shuhei/.my_help/sample_new.org\n"
        puts clear
      else
        puts miss
      end
    end
  end

  context'my_help new exist_file' do
    test_new_efile = command_line('my_help','new','sample')

    it 'exitstatus test' do
      if test_new_efile.exitstatus == 1
        puts clear
      else
        puts miss
        puts "同じ名前のファイルを作ろうとするとエラーが起きるのに対し，exitstatusが0で終了している"
      end
    end

    it 'stdout test' do
      if test_new_efile.stdout == "\"" + local_help_dir + "/sample.org\"\nFile exists. delete it first to initialize it.\n"
        puts clear
      else
        puts miss
      end
    end


    it 'stderr test' do
      if test_new_efile.stderr == ""
        puts clear
      else
        puts miss
      end
    end
  end
end


describe '#delete' do
  context'my_help delete' do
   test_delete = command_line('my_help','delete')

    it 'exitstatus test' do
      if test_delete.exitstatus == 1
        puts clear
      else
        puts miss
        puts "消去するfile名を指定していないのでエラーが出るのに対し，exitstatusが正常値の0で終了している．"
      end
    end

    it 'stdout test' do
      if test_delete.stdout == ""
        puts clear
      else
        puts miss
      end
    end


    it 'stderr test' do
      if test_delete.stderr == "ERROR: \"my_help delete\" was called with no arguments\nUsage: \"my_help delete HELP\"\nDeprecation warning: Thor exit with status 0 on errors. To keep this behavior, you must define `exit_on_failure?` in `MyCLI`\nYou can silence deprecations warning by setting the environment variable THOR_SILENCE_DEPRECATION.\n"
        puts clear
      else
        puts miss
      end
    end
  end

=begin
  context'my_help delete exist file' do
   test_delete_file = command_line('my_help','delete' ,'sample_new')

    it 'exitstatus test' do
      if test_delete_file.exitstatus == 0
        puts clear
      else
        puts miss
      end
    end

    it 'stdout test' do
      if test_delete_file.stdout == ""
        puts clear
      else
        puts miss
      end
    end


    it 'stderr test' do
      if test_delete_file.stderr == ""
        puts clear
      else
        puts miss
      end
    end
    end
=end

  context'my_help delete not existfile' do
   test_delete_nfile = command_line('my_help','delete','sample_delete')

    it 'exitstatus test' do
      if test_delete_nfile.exitstatus == 1
        puts clear
      else
        puts miss
        puts "存在しないfileを消そうとしているのでエラーが出るのに対し，exitstatusが正常値の0で終了している．"
      end
    end

    it 'stdout test' do
      if test_delete_nfile.stdout == local_help_dir + "/sample_delete.org is a non-existent file"
        puts clear
      else
        puts miss
      end
    end


    it 'stderr test' do
      if test_delete_nfile.stderr == ""
        puts clear
      else
        puts miss
      end
    end
  end
end

=begin
describe '#git [push|pull]' do
  context'my_help git push' do
p  test_git = command_line('my_help','git','push')

    it 'exitstatus test' do
      if test_git.exitstatus == 1
        puts clear
      else
        puts miss
      end
    end

    it 'stdout test' do
      if test_git.stdout == ""
        puts clear
      else
        puts miss
      end
    end


    it 'stderr test' do
      if test_git.stderr == "ERROR: \"my_help delete\" was called with no arguments\nUsage: \"my_help delete HELP\"\n"
        puts clear
      else
        puts miss
      end
    end
  end
end
=end
