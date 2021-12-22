# -*- coding: utf-8 -*-
require 'spec_helper'

RSpec.describe 'my_help', type: :aruba do

  context 'set editor stdout match' do
    expected = /set editor 'emacs'/

    before(:each) { run_command("my_help set_editor emacs -d=\'../../test\'")}
    before(:each) { stop_all_commands }
    # https://relishapp.com/philoserf/aruba/docs/command/access-stdout-of-command
    # You may need to #stop_all_commands
    # before accessing #stdout of a single command -
    # e.g. #last_command_started.
    # Relish英語訳して下さい．
    # arubaでtestした時は，起動dirが./tmp/arubaらしいです．．
    # testの下にあるmy_helpのtest dirを指すように-dで指定してね．
    it { expect(last_command_started.stdout).to match expected }
  end


  context 'set editor have_output matcher' do
    expected = /set editor 'emacs'/

    let(:my_help){run_command("my_help set_editor emacs -d=\'../../test\'")}
    # beforeではなく，letで変数(:my_help)に代入．
    it { expect(my_help).to have_output(expected) }
  end

  context 'version option' do
    before(:each){run_command('my_help version')}
    it { expect(last_command_started).to be_successfully_executed}
    it { expect(last_command_started).to have_output(/1.0b/) }
  end

  context "default help" do
    expected = /Commands:/
    # 長い出力の全文を一致させるのではなく，
    # 最初だけを示すRegExpに一致させるように変更
    let(:my_help){ run_command("my_help") }
    it { expect(my_help).to have_output(expected) }
  end

  context "default help start_with matcher" do
    expected = "my_help called with ''"
    # stop_all_commandsを使って，stdoutを取り出し，start_withを試した
    # とりあえず，こんなぐらいあればrspecは書けるかな？
    # raise_errorを試したい．．．
    before(:each) { run_command("my_help")}
    before(:each) { stop_all_commands }
    it { expect(last_command_started.stdout).to start_with expected }
  end

  context "command list" do
    expected = <<~EXPECTED
  my_help called with 'list -d=../../test'
  > default target dir : ../../test

  List all helps
         org: - emacs org-modeのhelp
        todo: - my todo
  my_help_test: - ヘルプのサンプル雛形
       emacs: - Emacs key bind
  EXPECTED
    before(:each) { run_command ("my_help list -d=\'../../test\'") }
    before(:each) { stop_all_commands }
    it { puts last_command_started.stdout }
    it { expect(last_command_started).to be_successfully_executed }
    it { expect(last_command_started.stdout).to eq(expected) }
  end
end


