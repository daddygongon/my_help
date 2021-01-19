# -*- coding: utf-8 -*-
Given("file 一覧を表示させたい") do
end

When("{string}と入力する") do |string|
end

Then("file 一覧が表示される") do
    MyHelp::Control.new.list_all
end
