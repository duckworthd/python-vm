#!/usr/bin/env bash
#
# Provision a new ubuntu box with my commonly used tools
# TODO get vim 7.4 --with-features=huge installed

set -e  # exit on error

function show() {
 echo "\$ $@"
 eval "$@"
}

# login as root
show apt-get update

# utilities I often use
show apt-get install -y aptitude

# python
show aptitude install -y \
  exuberant-ctags        \
  libatlas-dev           \
  liblapack-dev          \
  libmysqlclient-dev     \
  python-dev             \
  python-matplotlib      \
  python-numpy           \
  python-pip             \
  python-pip             \
  python-scipy           \

show pip install    \
  "configurati"     \
  "duxlib"          \
  "funcy"           \
  "gevent"          \
  "mirai>=0.1.3"    \
  "numpy"           \
  "pandas"          \
  "python-dateutil" \
  "requests"        \
  "sqlalchemy"      \
  "vaccine"         \
  "delorean"        \
  "isodate"         \
  "ipdb"            \

# cli utilities
show pip install \
  httpie         \
  ipython        \
  virtualenv     \

show aptitude install -y \
  autojump               \
  git                    \
  htop                   \
  jq                     \
  mtr                    \
  tmux                   \
  ack                    \

############################# Build VIM ########################################
# Install lua from binaries (these are out-of-date but at least they worked).
aptitude install -y liblua5.2-dev

# Remove old vims
aptitude remove -y vim vim-runtime gvim
aptitude remove -y vim-tiny vim-common vim-gui-common

# Download and build a new vim
aptitude install -y  \
  libncurses5-dev    \
  libgnome2-dev      \
  libgnomeui-dev     \
  libgtk2.0-dev      \
  libatk1.0-dev      \
  libbonoboui2-dev   \
  libcairo2-dev      \
  libx11-dev         \
  libxpm-dev         \
  libxt-dev          \
  python-dev         \
  ruby-dev           \
  mercurial          \

# get vim source code
cd ~
hg clone https://code.google.com/p/vim/ vim
cd vim

# build vim
./configure --with-features=huge                               \
            --enable-rubyinterp                                \
            --enable-pythoninterp                              \
            --with-python-config-dir=/usr/lib/python2.7-config \
            --enable-perlinterp                                \
            --enable-gui=gtk2 --enable-cscope --prefix=/usr    \
            --enable-luainterp                                 \
            --with-lua-prefix=/usr/local                       \

sudo make VIMRUNTIMEDIR=/usr/share/vim/vim74

# aaaaand install it
sudo make install

################################################################################

# ruby
show aptitude install -y \
  rbenv                  \

# dotfiles
cd ~
git clone https://github.com/duckworthd/vim-config.git dotfiles
cd dotfiles
git submodule init
git submodule update

ln   -s   dotfiles/.gitignore .
ln   -s   dotfiles/.tmux.conf .
ln   -s   dotfiles/.vim       .
ln   -s   dotfiles/.vimrc     .
ln   -s   dotfiles/.zsh       .
ln   -s   dotfiles/.zshrc     .
