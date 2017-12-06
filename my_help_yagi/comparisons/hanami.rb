#!/usr/bin/env ruby
require "bundler/setup"
require "hanami/cli"

module Foo
  module CLI
    module Commands
      extend Hanami::CLI::Registry

      class Greet < Hanami::CLI::Command
        argument :name, required: true, desc: "The name of the person to greet"

        def call(name:, **)
          result = "Hello #{name}"

          puts result
        end
      end

      register "hello", Greet
    end
  end
end

Hanami::CLI.new(Foo::CLI::Commands).call
