# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples
TZ='Asia/Hong_Kong'; export TZ
# If not running interactively, don't do anything
case $- in
	*i*) ;;
	  *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
	debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
	xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
	if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
	else
	color_prompt=
	fi
fi

if [ "$color_prompt" = yes ]; then
	PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
	PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
	PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
	;;
*)
	;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
	test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
	alias ls='ls --color=always'
	#alias dir='dir --color=always'
	#alias vdir='vdir --color=always'

	alias grep='grep --color=always'
	alias fgrep='fgrep --color=always'
	alias egrep='egrep --color=always'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.
if [ -f ~/.bash_aliases ]; then
	. ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
	if [ -f /usr/share/bash-completion/bash_completion ]; then
		. /usr/share/bash-completion/bash_completion
	elif [ -f /etc/bash_completion ]; then
		. /etc/bash_completion
	fi
fi

# get current branch in git repo
git_current_branch() {
        echo `git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
}

parse_git_branch() {
	BRANCH=`git_current_branch`
	if [ ! "${BRANCH}" == "" ]
	then
		OUT="─(${BRANCH})"
		STAT=`parse_git_dirty`
		if [ ! "${STAT}" == "" ]
		then
			OUT="${OUT}─[${STAT}]"
		fi
		echo "${OUT}"
	else
		echo ""
	fi
}

# get current status of git repo
parse_git_dirty() {
	status=`git status 2>&1 | tee`
	dirty=`echo -n "${status}" 2> /dev/null | grep "modified:" &> /dev/null; echo "$?"`
	untracked=`echo -n "${status}" 2> /dev/null | grep "Untracked files" &> /dev/null; echo "$?"`
	ahead=`echo -n "${status}" 2> /dev/null | grep "Your branch is ahead of" &> /dev/null; echo "$?"`
	newfile=`echo -n "${status}" 2> /dev/null | grep "new file:" &> /dev/null; echo "$?"`
	renamed=`echo -n "${status}" 2> /dev/null | grep "renamed:" &> /dev/null; echo "$?"`
	deleted=`echo -n "${status}" 2> /dev/null | grep "deleted:" &> /dev/null; echo "$?"`
	bits=''
	if [ "${renamed}" == "0" ]; then
		bits=">${bits}"
	fi
	if [ "${ahead}" == "0" ]; then
		bits="*${bits}"
	fi
	if [ "${newfile}" == "0" ]; then
		bits="+${bits}"
	fi
	if [ "${untracked}" == "0" ]; then
		bits="?${bits}"
	fi
	if [ "${deleted}" == "0" ]; then
		bits="x${bits}"
	fi
	if [ "${dirty}" == "0" ]; then
		bits="!${bits}"
	fi
	if [ ! "${bits}" == "" ]; then
		echo "${bits}"
	else
		echo ""
	fi
}

export PS1="\n\[\e[38;5;216m\]╭──\[\e[m\][\[\e[96m\]\w\[\e[m\]]─[\[\e[38;5;156m\]\u@\h\[\e[m\]]─[\[\e[34m\]\t \d\[\e[m\]]\[\e[33m\]\`parse_git_branch\`\[\e[m\]\n\[\e[38;5;216m\]╰────►\[\e[m\\e[38;5;226m\]\$\[\e[m\] "

if [ $UID -ne 0 ]; then
	alias update='sudo apt update && sudo apt upgrade'
fi

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../../'
alias c='clear' # ^L
alias cp='cp -i'
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

# Add an "alert" alias for long running commands. Use like so:
# sleep 10; alert
# alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

md() { command mkdir -v $1 && cd $1; }
cdf()
{
	if [ $# -eq 0 ] ; then
		builtin cd
	elif [ -d $1 ] ; then
		builtin cd "$1"
	else
		builtin cd "$(dirname $1)"
	fi
}
add_path()
{
    for ARG in "$@"
    do
        if [ -d "$ARG" ]
        then
            if [[ ":$PATH:" != *":$ARG:"* ]]
            then
                if ARGA=$(readlink -f "$ARG")           #notice me
                then
                    if [[ ":$PATH:" != *":$ARGA:"* ]]
                    then
                        PATH="${PATH:+"$PATH:"}$ARGA"
                    fi
                else
                    PATH="${PATH:+"$PATH:"}$ARG"
                fi
            fi
        else
            printf "path_add - ERROR: %s is not a directory.\n" "$ARG" >&2
        fi
    done
}
targz() { tar -zcvf $1.tar.gz $1; }
untargz() { tar -zxvf $1; }
backup() { cp -- "$1"{,.bak}; }

test -r ~/.bashrc.local && source ~/.bashrc.local
