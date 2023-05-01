#!/bin/sh

set -e

curl -LO https://invisible-island.net/datafiles/current/terminfo.src.gz
gunzip terminfo.src.gz
/usr/bin/tic -xe alacritty-direct,tmux-256color terminfo.src

