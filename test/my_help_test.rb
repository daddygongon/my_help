# -*- coding: utf-8 -*-
# frozen_string_literal: true

require "test_helper"
require "tmpdir"
require "fileutils"

# Learner Test
# Learner Test
class LearnerTest < Test::Unit::TestCase
  include Learner

  test "VERSION" do
    assert do
      ::Learner.const_defined?(:VERSION)
    end
  end

  test "Helloは\"Hello HOGEHOGE.\"を返す" do
    assert_equal("Hello Rudy.", Hello.new.run("Rudy"))
    assert_not_equal("Hello Rud.", Hello.new.run("Rudy"))
    assert_equal("Hello world.", Hello.new.run)
  end
end


