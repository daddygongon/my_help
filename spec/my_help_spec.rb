require 'spec_helper'

describe MyHelp::Command do
  before :each do
    print MyHelp::Command.run('-h')
  end
end
