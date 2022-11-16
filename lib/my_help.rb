# frozen_string_literal: true
require "thor"
require "fileutils"
require "pp"
require "yaml"
require_relative "my_help/version"
require_relative "my_help/list"
require_relative "my_help/config"
require_relative "my_help/modify"
require_relative "my_help/init"
require_relative "my_help/cli"
require_relative "my_help/org2hash"
require_relative "my_help/md2hash"

module MyHelp
  class Error < StandardError; end

  # Your code goes here...

end
