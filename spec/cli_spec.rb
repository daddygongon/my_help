# -*- coding: utf-8 -*-
require 'spec_helper'

RSpec.describe 'my_help', type: :aruba do
  context 'set editor' do
    expected = <<~EXPECTED
    my_help called with 'emacs'
    > default target dir : ../../test
    set editor 'emacs'
    EXPECTED

    before(:each){run_command("my_help set_editor emacs -d=\'../../test\'")}
    # arubaでtestした時は，起動dirが./tmp/arubaらしい．
    # testの下にあるmy_helpのtest dirを指すように-dで指定している．
    it { expect(last_command_started).to be_successfully_executed}
    it { expect(last_command_started).to have_output(expected) }
  end

  context 'version option' do
    before(:each){run_command('my_help version')}
    it { expect(last_command_started).to be_successfully_executed}
    it { expect(last_command_started).to have_output("0.9.0") }
  end


  context "# default help" do
    expected = <<~EXPECTED
       Commands:
         my_help delete HELP             # delete HELP
         my_help edit HELP               # edit HELP
         my_help git [push|pull]         # git push or pull
         my_help help [COMMAND]          # Describe available commands or one specific command
         my_help list [HELP] [ITEM]      # list all helps, specific HELP, or ITEM
         my_help new HELP                # make new HELP
         my_help set_editor EDITOR_NAME  # set editor to EDITOR_NAME
         my_help setup                   # set up the test database
         my_help version                 # show version

       Options:
         d, [--dir=DIR]
    
       EXPECTED

    before(:each) { run_command("my_help") }
    it { expect(last_command_started).to be_successfully_executed }
    it { expect(last_command_started).to have_output(expected) }
  end


end


