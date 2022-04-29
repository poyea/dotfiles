#!/bin/bash

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
				if ARGA=$(readlink -f "$ARG")			# notice me
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

# get last commit hash in git repo
git_last_hash()
{
	echo `git rev-parse HEAD 2> /dev/null`
}

# get current branch in git repo
git_current_branch()
{
	echo `git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
}

parse_git_branch()
{
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
parse_git_dirty()
{
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

trash()
{
	if [ ! -d "$HOME/.trash_can" ]; then
		mkdir "$HOME/.trash_can"
	fi

	for FILE in "$@"
	do
		mv "$FILE" "$HOME/.trash_can" && echo "$FILE"
	done
}