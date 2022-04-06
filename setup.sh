#!/bin/bash

DIR=$( cd $(dirname $0) ; pwd )


setup_ubuntu()
{
    ln -sf $DIR/ubuntu/.bashrc ~/.bashrc
    ln -sf $DIR/ubuntu/.tmux.conf ~/.tmux.conf
    ln -sf $DIR/ubuntu/.vimrc ~/.vimrc
}

select i in ubuntu exit
do
  case $i in
    ubuntu) setup_ubuntu;;
    exit) exit;;
  esac
done
