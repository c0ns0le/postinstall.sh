#!/bin/bash

#######
## Script de pos-instalacao para uma servidor de desenvolvimento/testes
## rodando Ubuntu
#######################################################################

INSTALA_PACOTES="sudo apt-get -q -y install "
REMOVE_PACOTES="sudo apt-get -q -y remove "

## Inclui usuario no sudoers, sem senha
########################################################################
SUDOER_LINE="$USER ALL=(ALL) NOPASSWD:ALL"
sudo grep "$SUDOER_LINE" /etc/sudoers.d/$USER > /dev/null 2> /dev/null
if [ $? -ne 0 ]
then
    sudo echo $SUDOER_LINE | sudo tee -a /etc/sudoers.d/$USER > /dev/null
    sudo chmod 0400 /etc/sudoers.d/$USER
fi


## Instala pacotes para desenvolvimento
########################################################################
sudo apt-get -qq update
sudo apt-get dist-upgrade

$INSTALA_PACOTES \
    alien \
    build-essential \
    checkinstall \
    curl \
    git \
    git-extras \
    libaio1 \
    libjpeg-dev \
    libpcre3-dev \
    libsasl2-dev \
    libssl-dev \
    libxml2-dev \
    libxslt1-dev \
    mercurial \
    p7zip-full \
    python-dev \
    python-pip \
    python-setuptools \
    python-virtualenv \
    ranger \
    rubygems \
    subversion \
    unixodbc-dev \
    vim \
    zlib1g-dev \
    zsh \
    ;

# Instala oh-my-zsh
curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | bash
chsh -s /usr/bin/zsh

# Reconfigura o idioma
$INSTALA_PACOTES --reinstall locales && sudo dpkg-reconfigure locales

# Limpa cache do apt
sudo apt-get clean

# Cria diretorios para cache do buildout
# Cria diretorios para cache do buildout
sudo mkdir -p /var/cache/buildout/eggs
sudo mkdir -p /var/cache/buildout/dlcache
sudo -E chown -R root.sudo /var/cache/buildout/ -R
sudo -E chmod g+ws /var/cache/buildout/eggs
sudo -E chmod g+ws /var/cache/buildout/dlcache