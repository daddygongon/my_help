# -*- coding: utf-8 -*-
require 'yaml'
require 'coderay'
require 'pp'
yaml =<<EOF
:file:
  :opts:
    :short: "-f"
    :long: "--ファイル"
    :desc: File操作
  :title: ファイル操作file
  :cont:
  - c-x c-f, Find file, ファイルを開く
  - c-x c-s, Save file, ファイルを保存
  - c-x c-w, Write file NAME, ファイルを別名で書き込む
EOF
pp data=YAML.load(yaml)
print YAML.dump(data)


data0={:new_item=>
  {:opts=>{:short=>"-n", :long=>"--new_item", :desc=>"new item"},
   :title=>"new_item",
   :cont=>
    ["new cont"]}}

print YAML.dump(data0)
puts CodeRay.scan(YAML.dump(data0),:yaml).term
puts CodeRay.scan(yaml,:yaml).term
