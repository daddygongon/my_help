require 'spec_helper'

RSpec.describe 'my_help', type: :aruba do
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
         my_help help [COMMAND]          # Describe available commands or one specif...
         my_help list [HELP] [ITEM]      # list all helps, specific HELP, or ITEM
         my_help new HELP                # make new HELP
         my_help set_editor EDITOR_NAME  # set editor to EDITOR_NAME
         my_help setup                   # set up the test database
         my_help version                 # show version
       EXPECTED
       
       before(:each) { run_command("my_help") }
       it { expect(last_command_started).to be_successfully_executed }
       it { expect(last_command_started).to have_output(expected) }
    end
  end
