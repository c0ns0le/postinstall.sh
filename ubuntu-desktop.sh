#!/bin/bash

#######
## Script de pos-instalacao para uma maquina de de desenvolvimento
## rodando Ubuntu
#######################################################################

INSTALA_PACOTES="sudo apt-get -qq install "
REMOVE_PACOTES="sudo apt-get -qq remove "


## Inclui usuario no sudoers, sem senha
########################################################################
SUDOER_LINE="$USER ALL=(ALL) NOPASSWD:ALL"
sudo grep "$SUDOER_LINE" /etc/sudoers.d/$USER > /dev/null 2> /dev/null
if [ $? -ne 0 ]
then
    sudo echo $SUDOER_LINE | sudo tee -a /etc/sudoers.d/$USER > /dev/null
    sudo chmod 0400 /etc/sudoers.d/$USER
fi


## Configura o proxy
########################################################################
AUTH_INPUT=$(zenity --username --password)

if [ "$AUTH_INPUT" != "" ]
then
    LOGIN=$(echo $AUTH_INPUT | cut -d '|' -f1)
    SENHA=$(echo $AUTH_INPUT | cut -d '|' -f2)
    PROXY_HOST=10.13.10.250
    PROXY_PORT=8080

    PROXY_URL=http://$LOGIN:$SENHA@$PROXY_HOST:$PROXY_PORT/

    #Configura proxy para apt e http
    sudo -S bash -c 'cat > /etc/apt/apt.conf.d/00proxy' << EOF
    Acquire{
        ftp::Proxy "$PROXY_URL";
        http::Proxy "$PROXY_URL";
        https::Proxy "$PROXY_URL";
    }
EOF

    sudo cat >> ~/.profile << EOF
export ftp_proxy="$PROXY_URL";
export http_proxy="$PROXY_URL";
export https_proxy="$PROXY_URL";
EOF

    #Configura proxy para subversion
    mkdir ~/.subversion/
    cat > ~/.subversion/servers << EOF
[global]
http-proxy-host = $PROXY_HOST
http-proxy-port = $PROXY_PORT
http-proxy-username = $LOGIN
http-proxy-password = $SENHA
EOF

    export ftp_proxy="$PROXY_URL";
    export http_proxy="$PROXY_URL";
    export https_proxy="$PROXY_URL";

fi


## Apaga alguns pacotes não-essenciais
########################################################################
$REMOVE_PACOTES \
    account-plugin-facebook \
    account-plugin-twitter \
    gwibber-service-facebook \
    gwibber-service-twitter \
    unity-lens-music \
    unity-lens-photos \
    unity-lens-shopping \
    unity-lens-video \
    ;


## Instala pacotes para desenvolvimento
########################################################################

# Repositorio para o Sublime Text 3
sudo -E add-apt-repository -y ppa:webupd8team/sublime-text-3

# Repositorio para o plugin do java
sudo -E add-apt-repository -y ppa:webupd8team/java

sudo apt-get -qq update

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

$INSTALA_PACOTES \
    sublime-text-installer \
    oracle-jdk7-installer \
    icedtea-7-plugin \
    chromium-browser \
    wireshark \
    xclip \
    ;

# Instala oh-my-zsh
curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | bash
chsh -s /usr/bin/zsh


## Instala o suporte a pt_BR
########################################################################
$INSTALA_PACOTES \
    hunspell-en-ca \
    hyphen-en-us \
    language-pack-gnome-pt \
    language-pack-pt \
    libreoffice-help-en-gb \
    libreoffice-help-pt \
    libreoffice-help-pt-br \
    libreoffice-l10n-en-gb \
    libreoffice-l10n-en-za \
    libreoffice-l10n-pt \
    libreoffice-l10n-pt-br \
    myspell-en-au \
    myspell-en-gb \
    myspell-en-za \
    myspell-pt \
    mythes-en-au \
    mythes-en-us \
    openoffice.org-hyphenation \
    wbrazilian \
    wbritish \
    wportuguese \
    ;


## Ajustes no Desktop
########################################################################
dconf write /com/canonical/indicator/datetime/show-date true
dconf write /com/canonical/indicator/datetime/show-day true
dconf write /com/canonical/unity/lenses/remote-content-search '"none"'
dconf write /com/canonical/unity/launcher/favorites '["application://nautilus.desktop", "application://chromium-browser.desktop", "application://sublime-text-2.desktop", "application://firefox.desktop", "unity://running-apps", "unity://expo-icon", "unity://devices"]'

# Cria diretorios para cache do buildout
sudo mkdir -p /var/cache/buildout/eggs
sudo mkdir -p /var/cache/buildout/dlcache
sudo -E chown -R root.sudo /var/cache/buildout/ -R
sudo -E chmod g+ws /var/cache/buildout/eggs
sudo -E chmod g+ws /var/cache/buildout/dlcache

# Limpa cache do apt
sudo apt-get clean

# Cria chave ssh
ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa -q
ssh-add
