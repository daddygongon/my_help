# -*- coding: utf-8 -*-
require 'spec_helper'
require 'my_help'

RSpec.describe 'edit' do
  context "#edit" do
    it "open file sample.yml" do
      expect(command_line((MyHelp::Control.new.edit_help('sample')).to_s).success?).to be true
    end
    it "exitstatus open file sample.yml" do
      expect(command_line((MyHelp::Control.new.edit_help('sample')).to_s).exitstatus).to eq(0)
    end
  end
end
