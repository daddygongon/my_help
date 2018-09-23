# -*- coding: utf-8 -*-
file = 'README'

desc 'push platex.rake to local gem'
task :push do
  system "cp -i platex.rake ~/Github/ornb/lib/platex"
end
task :default do
  system 'rake -f platex.rake -T'
end

desc "mid_presen"
task :mid do
  textheight =<<'EOS'
\setlength{\textheight}{275mm}
\headheight 5mm
\topmargin -30mm
\textwidth 185mm
\oddsidemargin -15mm
\evensidemargin -15mm
\pagestyle{empty}
EOS

title_author =<<'EOS'
\title{EAMを用いた歪み解析}
\author{情報科学科 \hspace{5mm} 19610311 \hspace{5mm} 西谷滋人}
\date{}
EOS
  cont = File.read("#{file}.tex")
  cont.gsub!('{jsarticle}','[a4j,twocolumn]{jsarticle}')
#  cont.gsub!('{graphicx}','[dvipdfmx]{graphicx}')
  cont.gsub!('{hyperref}',"[dvipdfmx]{hyperref}\n\\usepackage{pxjahyper}")
  cont.gsub!(/\\setcounter{secnumdepth}{(.+?)}/, textheight)
  cont.gsub!(/\\author{(.+?)}/,'')
  cont.gsub!(/\\date{(.+?)}/,'')
  cont.gsub!(/\\title{(.+?)}/, title_author)
  cont.gsub!(/\\tableofcontents/,'')
  File.open("#{file}.tex",'w'){ |f| f.print cont }
  system "rake -f #{__FILE__} platex"
end

desc "platex"
task :platex do
  p file
  cont = File.read("#{file}.tex")
  File.open("#{file}.tex",'w'){ |f| f.print cont }
  system "platex #{file}"
  commands = ["platex #{file}.tex",
              "bibtex #{file}.tex",
              "platex #{file}.tex",
              "dvipdfmx #{file}.dvi",
              "open #{file}.pdf"]
  commands.each{|com| system com}
end
