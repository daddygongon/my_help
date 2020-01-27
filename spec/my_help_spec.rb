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

      message = "error: No help named 'sample_list_test' in the directory '" + local_help_dir + "'.\n"
      if test_list_a.stderr == message
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
      message = <<'EOS'
ERROR: "my_help edit" was called with no arguments
Usage: "my_help edit HELP"
Deprecation warning: Thor exit with status 0 on errors. To keep this behavior, you must define `exit_on_failure?` in `MyCLI`
You can silence deprecations warning by setting the environment variable THOR_SILENCE_DEPRECATION.
EOS

      if test_edit.stderr == message
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
      message = "\"" +local_help_dir + "/sample.org\"\n"
      if test_edit_a.stdout == message
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
      message = "\"" + local_help_dir + "/sample_edit.org\"\nfile " + local_help_dir + "/sample_edit.org does not exits in " + local_help_dir + ".\ninit sample_edit first.\n"
      if test_edit_b.stdout == message
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
      message = <<'EOS'
ERROR: "my_help new" was called with no arguments
Usage: "my_help new HELP"
Deprecation warning: Thor exit with status 0 on errors. To keep this behavior, you must define `exit_on_failure?` in `MyCLI`
You can silence deprecations warning by setting the environment variable THOR_SILENCE_DEPRECATION.
EOS
      if test_new.stderr == message
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
      message = <<'EOS'
"/Users/Shuhei/.my_help/sample_new.org"
"/Users/Shuhei/.rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/gems/my_help-0.8.5/lib/templates/help_template.org"
EOS
      if test_new_file.stdout == message
        puts clear
      else
        puts miss
      end
    end


    it 'stderr test' do
      message = "cp /Users/Shuhei/.rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/gems/my_help-0.8.5/lib/templates/help_template.org /Users/Shuhei/.my_help/sample_new.org\n"
      if test_new_file.stderr == message
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
      message = "\"" + local_help_dir + "/sample.org\"\nFile exists. delete it first to initialize it.\n"
      if test_new_efile.stdout == message
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
      message = <<'EOS'
ERROR: "my_help delete" was called with no arguments
Usage: "my_help delete HELP"
Deprecation warning: Thor exit with status 0 on errors. To keep this behavior, you must define `exit_on_failure?` in `MyCLI`
You can silence deprecations warning by setting the environment variable THOR_SILENCE_DEPRECATION.
EOS
      if test_delete.stderr == message
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
      message = local_help_dir + "/sample_delete.org is a non-existent file"
      if test_delete_nfile.stdout == message
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


describe '#git [push|pull]' do

  context'my_help git other than [push|pull]'do
    test_git = command_line('my_help','git','a')
    it'exitstatus test' do
      if test_git.exitstatus == 1
        puts clear
      else
        puts miss
      end
    end

    it 'stdout test' do
      if test_git.stdout == "\"a\"\n"
        puts clear
      else
        puts miss
      end
    end

    it 'stderr test' do
      message = <<'EOS'
/Users/Shuhei/.rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/gems/my_help-0.8.5/exe/my_help:132:in `block in git': my_help git was called by the other than 'push or pull' (RuntimeError)
	from /Users/Shuhei/.rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/gems/my_help-0.8.5/exe/my_help:104:in `chdir'
	from /Users/Shuhei/.rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/gems/my_help-0.8.5/exe/my_help:104:in `git'
	from /Users/Shuhei/.rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/gems/thor-1.0.1/lib/thor/command.rb:27:in `run'
	from /Users/Shuhei/.rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/gems/thor-1.0.1/lib/thor/invocation.rb:127:in `invoke_command'
	from /Users/Shuhei/.rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/gems/thor-1.0.1/lib/thor.rb:392:in `dispatch'
	from /Users/Shuhei/.rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/gems/thor-1.0.1/lib/thor/base.rb:485:in `start'
	from /Users/Shuhei/.rbenv/versions/2.5.1/lib/ruby/gems/2.5.0/gems/my_help-0.8.5/exe/my_help:148:in `<top (required)>'
	from /Users/Shuhei/.rbenv/versions/2.5.1/bin/my_help:23:in `load'
	from /Users/Shuhei/.rbenv/versions/2.5.1/bin/my_help:23:in `<main>'
EOS
      if test_git.stderr == message
        puts clear
      else
        puts miss
      end
    end
  end

  context'my_help git push' do
    test_git = command_line('my_help','git','push')

    it 'exitstatus test' do
      if test_git.exitstatus == 0
        puts clear
      else
        puts miss
      end
    end

    it 'stdout test' do
      message = "\"push\"\n\n\n\e[0;34;49mOn branch master\nYour branch is up-to-date with 'origin/master'.\n\nnothing to commit, working tree clean\n\e[0m\n\n\n\e[0;31;49mEverything up-to-date\n\e[0m\n"
      if test_git.stdout == message
        puts clear
      else
        puts miss
      end
    end


    it 'stderr test' do
      if test_git.stderr == ""
        puts clear
      else
        puts miss
      end
    end
  end


  context'my_help git push exist file' do
    test_git = command_line('my_help','git','push','sample')

    it 'exitstatus test' do
      if test_git.exitstatus == 0
        puts clear
      else
        puts miss
      end
    end

    it 'stdout test' do
      message	= "\"push\"\n\n\n\e[0;34;49mOn branch master\nYour branch is up-to-date with 'origin/master'.\n\nnothing to commit, working tree clean\n\e[0m\n\n\n\e[0;31\
;49mEverything up-to-date\n\e[0m\n"
      if test_git.stdout == message
        puts clear
      else
        puts miss
      end
    end


    it 'stderr test' do
      if test_git.stderr == ""
        puts clear
      else
        puts miss
      end
    end
  end

 context'my_help git push not exist file' do
    test_git = command_line('my_help','git','push','zzzz')

    it 'exitstatus test' do
      if test_git.exitstatus == 0
        puts clear
      else
        puts miss
      end
    end

    it 'stdout test' do
      message	= "\"push\"\n\e[0;31;49m/Users/Shuhei/.my_help/zzzz.org does not existed\e[0m\n\e[0;34;49mOn branch master\nYour branch is up-to-date with 'origin/master'.\n\nnothing to commit, working tree clean\n\e[0m\n\n\n\e[0;31;49mEverything up-to-date\n\e[0m\n"
      if test_git.stdout == message
        puts clear
      else
        puts miss
      end
    end


    it 'stderr test' do
      if test_git.stderr == ""
        puts clear
      else
        puts miss
      end
    end
  end

 context'my_help git push specified files' do
 p  test_git = command_line('my_help','git','push','sample','sample1','sample2')

    it 'exitstatus test' do
      if test_git.exitstatus == 0
        puts clear
      else
        puts miss
      end
    end

    it 'stdout test' do
      message	= "\"push\"\n\n\n\n\n\n\n\e[0;34;49mOn branch master\nYour branch is up-to-date with 'origin/master'.\n\nnothing to commit, working tree clean\n\e[0m\n\n\n\e[0;31;49mEverything up-to-date\n\e[0m\n"
      if test_git.stdout == message
        puts clear
      else
        puts miss
      end
    end


    it 'stderr test' do
      if test_git.stderr == ""
        puts clear
      else
        puts miss
      end
    end
  end



  context'my_help git pull' do
    test_git = command_line('my_help','git','pull')

    it 'exitstatus test' do
      if test_git.exitstatus == 0
        puts clear
      else
        puts miss
      end
    end

    it 'stdout test' do
      message = "\"pull\"\n\e[0;34;49mAlready up-to-date.\n\e[0m\n\e[0;31;49mFrom https://github.com/shuhei555/sample\n * branch            master     -> FETCH_HEAD\n\e[0m\n"
      if test_git.stdout == message
        puts clear
      else
        puts miss
      end
    end


    it 'stderr test' do
      if test_git.stderr == ""
        puts clear
      else
        puts miss
      end
    end
  end
end

