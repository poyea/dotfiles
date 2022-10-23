alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../../'
alias c='clear' # ^L
alias cp='cp -i'
alias dirsize='du -sh'
alias diskspace='df -h'
alias hg='history | grep'
alias l='ls --color=always' 
alias ll='ls -la --color=always'
alias ln='ln -i'
alias mkdir='mkdir -pv'
alias mv='mv -i'
alias myip='curl http://ifconfig.me/ip'
alias ports='netstat -tulanp'
alias reboot='sudo reboot'
alias reload='. $HOME/.bashrc'
alias reloadapache='sudo systemctl reload apache2'
alias rm='rm -I'
alias sortcnt='sort | uniq -c | sort -nr'

if [ $UID -ne 0 ]; then
	alias update='sudo apt update && sudo apt upgrade'
fi

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
	test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
	alias ls='ls --color=always'
	alias dir='dir --color=always'
	alias vdir='vdir --color=always'

	alias grep='grep --color=always'
	alias fgrep='fgrep --color=always'
	alias egrep='egrep --color=always'
fi
