set path=(~/.rbenv/shims /usr/local/bin /usr/bin $path /sbin \
/usr/sbin . /usr/local/mysql/bin /usr/local/teTeX/bin ~/bin)

set HOSTNAME=`hostname -s`

setenv MANPATH /usr/share/man:/usr/man:/usr/catman:/usr/local/man:/usr/local/catman:/usr/unsupported/man:/export/man:/usr/local/teTeX/man

alias lhiki 'ls \!:1| nkf --url-input -w'
alias setproxy 'setenv http_proxy http://proxy.kwansei.ac.jp:8080; setenv https_proxy http://proxy.kwansei.ac.jp:8080'
alias unsetproxy 'unsetenv http_proxy http://proxy.kwansei.ac.jp:8080; unsetenv https_proxy http://proxy.kwansei.ac.jp:8080'
alias startNUM 'cd /Users/bob/Desktop/Lectures/NumericalRecipe/NumRecipe16/Gradings'
alias startModebutu 'cd /Users/bob/Desktop/Lectures/ModelPhys/ModelPhys/2016/Gradings'
alias ls 'ls -vCFG'
alias ll 'ls -al'
alias rm 'rm -i'
alias mv 'mv -i'
alias cp 'cp -i'
alias bye 'exit'
alias h history
alias sshmail '~/bin/killkscmail; ssh -N -f -L 60025:kscmail.ksc.kwansei.ac.jp:25 -L 60143:kscmail.ksc.kwansei.ac.jp:143 bob@192.218.172.38'
alias tidy '\rm *[%~#] .*[%~#] core *.log *.dvi *.aux pout.dat *.bak *.synctex.gz'
alias rsyncPut 'rsync --exclude .git -auvz -e ssh ~/Sites/new_ist/ nishitani@ist.ksc.kwansei.ac.jp:~/public_html'
alias BackUp 'rsync -auvz --delete --exclude Library --exclude VirtualBox\ VMs --exclude Dropbox --exclude Movies -e ssh ~/ bob@192.168.3.33:~/'
alias Emacs 'open -a Emacs.app'
alias maple '/Library/Frameworks/Maple.framework/Versions/Current/bin/maple'

set history=100
set savehist=100
setenv EDITOR emacs

alias cd 'cd \!*;printf "\033]1;%s\007\033]2;%s\007" "$cwd:t" "$cwd" '

set notify
set filec


