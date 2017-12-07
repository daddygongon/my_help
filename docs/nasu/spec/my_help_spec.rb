# -*- coding: utf-8 -*-
require "./spec_helper.rb"

RSpec.describe 'my_help command', type: :aruba do
  context 'version option' do
    before(:each) { run('my_help -v') }
    it { expect(last_command_started).to be_successfully_executed }
    it { expect(last_command_started).to have_output("my_help 0.4.5") }
  end

  context 'help option' do
    expected = <<EXPECTED
Usage: my_help [options]
    -v, --version                    show program Version.
    -l, --list                       list specific helps
    -e, --edit NAME                  edit NAME help(eg test_help)
    -i, --init NAME                  initialize NAME help(eg test_help)
    -m, --make                       make executables for all helps
    -c, --clean                      clean up exe dir.
        --install_local              install local after edit helps
        --delete NAME                delete NAME help
EXPECTED
    before(:each) { run('my_help -h') }
    it { expect(last_command_started).to be_successfully_executed }
    it { expect(last_command_started).to have_output(expected.chomp) }
  end

  context 'init option1' do
    before(:each) { run('my_help -i test_help') }

    expected=<<EOS
"/Users/OyagiToshiharu/.my_help/test_help.yml"
File exists. rm it first to initialize it.
EOS
    it { expect(last_command_started).to be_successfully_executed }
    it { expect(last_command_started).to have_output(expected.chomp) }
  end


  context 'edit option' do
    expected = <<EXPECTED
#<OptionParser::MissingArgument: -e>
EXPECTED
  before(:each) { run('my_help -e') }
  it { expect(last_command_started).to be_successfully_executed }
  it { expect(last_command_started).to have_output(expected.chomp) }
  end

  context 'init option2' do
    expected = <<EXPECTED
#<OptionParser::MissingArgument: -i>
EXPECTED
  before(:each) { run('my_help -i') }
  it { expect(last_command_started).to be_successfully_executed }
  it { expect(last_command_started).to have_output(expected.chomp) }
  end

  context 'make option' do
    expected = <<EXPECTED
"exe/my_todo"
#<Errno::ENOENT: No such file or directory @ rb_sysopen - exe/my_todo>
EXPECTED
    before(:each) { run('my_help -m') }
    it { expect(last_command_started).to be_successfully_executed }
    it { expect(last_command_started).to have_output(expected.chomp) }
  end

  context 'list option' do
    expected = "Specific help file:\n  my_todo\t:my todo\n  emacs_help\t:emacsのキーバインド\n  test_help\t:ヘルプのサンプル雛形\n"

    before(:each) { run('my_help -l') }
    it { expect(last_command_started).to be_successfully_executed }
    it { expect(last_command_started).to have_output(expected.chomp) }
  end
end
