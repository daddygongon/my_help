# -*- coding: utf-8 -*-
require 'spec_helper'
require 'my_help'

RSpec.describe 'delete option sample' do
  context 'exit file' do
  it 'user input  n' do
      allow(STDIN).to receive(:gets) {'n'}
      expect(MyHelp::Control.new.delete_help('sample')).to eq(0)
    end
  it 'user input q' do
      allow(STDIN).to receive(:gets) {'q'}
      expect(MyHelp::Control.new.delete_help('sample')).to eq(0)
    end
  it 'user input Y' do
      allow(STDIN).to receive(:gets) {'Y'}
      expect(MyHelp::Control.new.delete_help('sample')).to eq(0)
    end
  end
  context 'not exit file' do
    it 'user input Y' do
      allow(STDIN).to receive(:gets) {'Y'}
      expect(MyHelp::Control.new.delete_help('zzzzzz')).to eq(1)
    end
  end
end
