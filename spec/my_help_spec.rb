# coding: utf-8
# frozen_string_literal: true

RSpec.describe MyHelp do
  include MyHelp

  it "has a version number" do
    expect(MyHelp::VERSION).not_to be nil
  end

  describe "MyHelp::SetEditor" do
    subject(:set_editor) {MyHelp::SetEditor.new}

    describe "run with an arg 'moeko'" do
      it {expect(set_editor.start('moeko')).to eq('my_help called with moeko
        set editor moeko')}
    end
  end
end
