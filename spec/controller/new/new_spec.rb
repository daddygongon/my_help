require 'spec_helper'
require 'my_help'

RSpec.describe 'new option sample' do
  context "#new" do
    it "make file sample_new.yml" do
      expect(command_line((MyHelp::Control.new.init_help('sample')).to_s).success?).to be true
    end
  end
end
