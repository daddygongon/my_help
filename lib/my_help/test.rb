# -*- coding: utf-8 -*-
require 'yaml'
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


data0={:file=>
  {:opts=>{:short=>"-f", :long=>"--ファイル", :desc=>"File操作"},
   :title=>"ファイル操作file",
   :cont=>
    ["c-x c-f, Find file, ファイルを開く
     c-x c-s, Save file, ファイルを保存
     c-x c-w, Write file NAME, ファイルを別名で書き込む"]}}

print YAML.dump(data0)
