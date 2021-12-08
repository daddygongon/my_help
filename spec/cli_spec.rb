require 'spec_helper'

RSpec.describe 'my_help', type: :aruba do
  context 'edit option' do

    expected = <<~EXPECTED
    my_help called with 'todo'
    "/Users/higashibatamoeko/.my_help/todo.org"
    EXPECTED

    before(:each){run_command('my_help edit todo')}
    it { expect(last_command_started).to be_successfully_executed}
    it { expect(last_command_started).to have_output(expected) }
  end

  context 'set editor option' do

    expected = <<~EXPECTED
    my_help called with 'emacs'
    set editor 'emacs'
    EXPECTED

    before(:each){run_command('my_help set_editor emacs')}
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
      my_help delete HELP                     # delete HELP
      my_help edit HELP                       # edit HELP
      my_help git [push|pull]                 # git push or pull
      my_help help [COMMAND]                  # Describe available commands or on...
      my_help list [HELP] [ITEM] -d='./test'  # list all helps, specific HELP, or...
      my_help new HELP                        # make new HELP
      my_help set_editor EDITOR_NAME          # set editor to EDITOR_NAME
      my_help setup                           # set up the test database
      my_help version                         # show version
  
    Options:
      d, [--dir=DIR] 
  EXPECTED
    
    before(:each) { run_command("my_help") }
    it { expect(last_command_started).to be_successfully_executed }
    it { expect(last_command_started).to have_output(expected) }
  end


end


