#!/bin/bash

setup_ubuntu()
{
    ln -sf ./ubuntu/.bashrc .bashrc
    ln -sf ./ubuntu/.tmux.conf .tmux.conf
    ln -sf ./ubuntu/.vimrc .vimrc
}

select i in ubuntu exit
do
  case $i in
    ubuntu) setup_ubuntu;;
    exit) exit;;
  esac
done
