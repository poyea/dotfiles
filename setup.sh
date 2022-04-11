#!/bin/bash

DIR=$(cd $(dirname $0) ; pwd)

setup_ubuntu()
{
    for file in $DIR/ubuntu/.*; do
      [ -d "$file" ] && continue
      ln -si $file ~/$(basename $file)
    done
}

select i in ubuntu exit
do
  case $i in
    ubuntu)
        setup_ubuntu
        exit
        ;;
    exit) exit;;
  esac
done
