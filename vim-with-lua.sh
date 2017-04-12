#!/bin/sh

sudo apt-get remove --purge vim vim-runtime vim-gnome vim-tiny vim-gui-common

sudo apt-get install liblua5.2-dev luajit libluajit-5.2 python-dev ruby-dev libperl-dev libncurses5-dev libatk1.0-dev libx11-dev libxpm-dev libxt-dev

sudo rm -rf /usr/local/share/vim

sudo rm /usr/bin/vim

sudo mkdir /usr/include/lua5.2/include
sudo cp /usr/include/lua5.2/*.h /usr/include/lua5.2/include/

git clone https://github.com/vim/vim
#git pull && git fetch
cd vim/src
make distclean # if vim was prev installed
./configure --with-features=huge \
            --enable-rubyinterp \
            --enable-largefile \
            --disable-netbeans \
            --enable-pythoninterp \
            --with-python-config-dir=/usr/lib/python2.7/config \
            --enable-perlinterp \
            --enable-luainterp \
            --with-luajit \
            --enable-fail-if-missing \
            --with-lua-prefix=/usr/include/lua5.2 \
            --enable-cscope

make 
sudo make install

# alias vi="vim" in .zshrc / .bashrc
