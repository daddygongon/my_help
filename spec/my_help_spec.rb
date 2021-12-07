# frozen_string_literal: true

RSpec.describe MyHelp do
  include MyHelp

  it "has a version number" do
    expect(MyHelp::VERSION).not_to be nil
  end
end
