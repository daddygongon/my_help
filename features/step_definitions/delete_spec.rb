# -*- coding: utf-8 -*-
Given("sample_new.yml file を削除したい") do

end

When("{string} と入力") do |string|

end

Then("file を削除する") do
  MyHelp::Control.new.delete_help("sample_new")
end
