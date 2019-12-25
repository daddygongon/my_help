# -*- coding: utf-8 -*-

Given("sampleファイルを編集したい") do
end

When("{string}  と入力する") do |string|
end

Then("sampleファイルが開く") do
   MyHelp::Control.new.edit_help("sample")
end

And("sampleファイルを書き換える") do
end
