#!/bin/bash

DIR=$(cd $(dirname $0) ; pwd)

setup_ubuntu()
{
  for file in $DIR/ubuntu/.*; do
    [ -d "$file" ] && continue
    ln -si $file ~/$(basename $file)
  done
}

exists()
{
  command -v $1 1>/dev/null 2>&1 || return 1
  return 0
}

check_utils()
{
  for cmd in bat vim htop
  do
    if ! exists $cmd; then echo "Cannot find $cmd"; fi
  done
}

select i in ubuntu check exit
do
  case $i in
    ubuntu)
      setup_ubuntu
      exit
      ;;
    check)
      check_utils
      exit
      ;;
    exit) exit;;
  esac
done
