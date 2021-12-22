# -*- coding: utf-8 -*-
require 'command_line/global'

HEAD =<<EOS
#+OPTIONS: ^:{}
#+STARTUP: indent nolineimages
#+OPTIONS:   toc:nil
#+TAG: Ruby, test, my_help
#+SETUPFILE: https://fniessen.github.io/org-html-themes/org/theme-readtheorg.setup
EOS
Dir.glob("./*.md")[0..1].each do |file|
  output = [File.basename(file, '.md'),'.org'].join
  puts "- [[file:./#{output}]]"
  res = command_line "pandoc -f markdown -t org -o #{output} #{file}"
  puts res.stdout
  # system "emacs #{output} --batch --load ~/.emacs.d/init.el -f org-html-export-to-html --kill"
  # -l ./htmlize.el 試したがうまくcolorizeされない．htmlでの表示を諦める．
  # https://qiita.com/daddygongon/items/298e3e351bf15cfaa699 参照

  org_content = File.read(output)
  File.open(output,'w') do |f|
    f.print HEAD
    f.print org_content
  end

  res = command_line "qiita post #{output}"
   "head -1 #{output}"
end
