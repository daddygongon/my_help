# -*- coding: utf-8 -*-
require 'spec_helper'
require 'my_help'

RSpec.describe 'my_help command', type: :aruba do
  describe '#help' do
    context 'help' do
    expected = <<~EXPECTED
    Commands:
      my_help_thor delete {help_name}       # delete HELP_NAME
      my_help_thor edit {help_name}         # edit HELP_NAME
      my_help_thor help [COMMAND]           # Describe available commands or one ...
      my_help_thor list                     # list all helps, specific HELP, or item
      my_help_thor new {help_name}          # make new HELP_NAME
      my_help_thor search {find_char}       # search FIND_CHAR
      my_help_thor tomo_upload {help_name}  # tomo_upload HELP_NAME
    EXPECTED
    before(:each) { run_command('bundle exec ../bin/my_help_thor help') }
    it { expect(last_command_started).to be_successfully_executed }
    it { expect(last_command_started).to have_output(expected) }
    end

    context 'help delete' do
      expected = "Usage:\n  my_help_thor delete {help_name}\n\ndelete HELP_NAME"
      before(:each) { run_command('bundle exec ../bin/my_help_thor help delete') }
      it { expect(last_command_started).to be_successfully_executed }
      it { expect(last_command_started).to have_output(expected) }
    end

    context 'help edit' do
      expected = "Usage:\n  my_help_thor edit {help_name}\n\nedit HELP_NAME"
      before(:each) { run_command('bundle exec ../bin/my_help_thor help edit') }
      it { expect(last_command_started).to be_successfully_executed }
      it { expect(last_command_started).to have_output(expected) }
    end

    context 'help list' do
      expected = "Usage:\n  my_help_thor list\n\nlist all helps, specific HELP, or item"
      before(:each) { run_command('bundle exec ../bin/my_help_thor help list') }
      it { expect(last_command_started).to be_successfully_executed }
      it { expect(last_command_started).to have_output(expected) }
    end

    context 'help new' do
      expected = "Usage:\n  my_help_thor new {help_name}\n\nmake new HELP_NAME"
      before(:each) { run_command('bundle exec ../bin/my_help_thor help new') }
      it { expect(last_command_started).to be_successfully_executed }
      it { expect(last_command_started).to have_output(expected) }
    end

    context 'help search' do
      expected = "Usage:\n  my_help_thor search {find_char}\n\nsearch FIND_CHAR"
      before(:each) { run_command('bundle exec ../bin/my_help_thor help search') }
      it { expect(last_command_started).to be_successfully_executed }
      it { expect(last_command_started).to have_output(expected) }
    end
  end

  context 'new option' do
    expected = "\"/Users/Shuhei/.my_help/aruba.org\"\nFile exists. delete it first to initialize it."
    before(:each) { run_command('bundle exec ../bin/my_help_thor new aruba')}
    it{expect(last_command_started).to be_successfully_executed}
    it{expect(last_command_started).to have_output(expected)}
  end

  describe 'edit option' do
    context 'exist file' do
      expected = "\"/Users/Shuhei/.my_help/aruba.org\"\nemacs: standard input is not a tty"
      before(:each) { run_command('bundle exec ../bin/my_help_thor edit aruba')}
      it{expect(last_command_started).to be_successfully_executed}
      it{expect(last_command_started).to have_output(expected)}
    end
    context 'not exist file' do
      expected = "\"/Users/Shuhei/.my_help/aruba2.org\"\nfile /Users/Shuhei/.my_help/aruba2.org does not exits in /Users/Shuhei/.my_help.\ninit aruba2 first."
      before(:each) { run_command('bundle exec ../bin/my_help_thor edit aruba2')}
      it{expect(last_command_started).to be_successfully_executed}
      it{expect(last_command_started).to have_output(expected)}
    end
  end

  describe 'list option' do
    context 'list' do
      expected = "List all helps\n     aruba: - ヘルプのサンプル雛形\n       org: - emacs org-modeのhelp\n      todo: - my todo\n      blog: - blog\n     emacs: - Emacs key bind"
      before(:each) { run_command('bundle exec ../bin/my_help_thor list ')}
      it{expect(last_command_started).to be_successfully_executed}
      it{expect(last_command_started).to have_output(expected)
      }
    end
    context 'list todo' do
      expected = "- my todo\n     , head           : head\n     , license        : license\n   -d, daily          : daily\n   -w, weekly         : weekly"
      before(:each) { run_command('bundle exec ../bin/my_help_thor list todo')}
      it{expect(last_command_started).to be_successfully_executed}
      it{expect(last_command_started).to have_output(expected)}
    end
    context 'list todo -d' do
      expected = "- my todo\n-----\ndaily\n- ご飯を食べる\n- 10時には寝床へ入る"
      before(:each) { run_command('bundle exec ../bin/my_help_thor list todo -d')}
      it{expect(last_command_started).to be_successfully_executed}
      it{expect(last_command_started).to have_output(expected)}
    end
  end


  describe 'delete option' do
    expected = "Are you sure to delete /Users/Shuhei/.my_help/aruba.org?[Ynq] "
    before(:each) {run_command('bundle exec ../bin/my_help_thor delete aruba')}
    it{expect(last_command_started).to have_output(expected)}
  end
end

