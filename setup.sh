#!/bin/bash

DIR=$(cd $(dirname $0) ; pwd)

setup_ubuntu()
{
    ln -si $DIR/ubuntu/.bashrc ~/.bashrc
    ln -si $DIR/ubuntu/.bash_aliases ~/.bash_aliases
    ln -si $DIR/ubuntu/.bashrc.local ~/.bashrc.local
    ln -si $DIR/ubuntu/.bash_funcs.sh ~/.bash_funcs.sh

    ln -si $DIR/ubuntu/.tmux.conf ~/.tmux.conf
    ln -si $DIR/ubuntu/.vimrc ~/.vimrc
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
