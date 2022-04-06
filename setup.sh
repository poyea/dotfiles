#!/bin/bash

DIR=$( cd $(dirname $0) ; pwd )


setup_ubuntu()
{
    ln -sf $DIR/ubuntu/.bashrc ~/.bashrc
    ln -sf $DIR/ubuntu/.bash_aliases ~/.bash_aliases
    ln -sf $DIR/ubuntu/.bashrc.local ~/.bashrc.local
    ln -sf $DIR/ubuntu/.funcs.sh ~/.funcs.sh
    ln -sf $DIR/ubuntu/.tmux.conf ~/.tmux.conf
    ln -sf $DIR/ubuntu/.vimrc ~/.vimrc
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
