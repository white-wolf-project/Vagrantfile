#!/usr/bin/env bash
#######################################################################
#
#  Project......: bootstrap.sh
#  Creator......: matteyeux
#  Description..: setup vagrant box running Debian Stretch
#				  copy this line to your Vagrantfile if not here : 
#				  config.vm.provision :shell, path: "bootstrap.sh"
#				  To update run : vagrant reload --provision
#  Type.........: Public
#
######################################################################
# Language :
#               bash
# Version : 0.1
#
#  Change Log
#  ==========
#
#   ===============================================================
#    Date     |       Who          |      What
#   ---------------------------------------------------------------
#    06/12/17 |     matteyeux      | Script creation
#   ---------------------------------------------------------------
#    11/12/17 |     matteyeux      | added ZSH and htop
#   ---------------------------------------------------------------

apt-get update && apt-get upgrade -y

# install build tools 
apt-get install -y make build-essential libssl-dev wget git python3 apache2 m4 autoconf libtool autotools-dev libiw-dev vim zsh htop samba mysql-server mysql-client

# install git stuff 
git clone https://github.com/matteyeux/sysnet; cd sysnet
./scripts/install.sh
make install
cd ..


# few vim settings
echo "set nu" >> /etc/vim/vimrc 		# set line numbers
echo "set autoindent" >> /etc/vim/vimrc	# auto indentation
echo "set tabstop=4" >> /etc/vim/vimrc	# tab = 4 spaces (but tabs)
echo "set showmatch" >> /etc/vim/vimrc	# parentheses/brackets highlight when matching


# oh my zsh
if [[ ! -e "/home/vagrant/.oh-my-zsh" ]]; then
	wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | sh
	sudo chsh -s /bin/zsh vagrant
	cp -r /root/.oh-my-zsh /root/.zshrc /home/vagrant
	chown -R vagrant .oh-my-zsh/ .zshrc 
	#sed -i '/  export ZSH=/root/.oh-my-zsh/c\  export ZSH=/home/vagrant/.oh-my-zsh' /home/vagrant/.zshrc
	echo "export ZSH=/home/vagrant/.oh-my-zsh" > /home/vagrant/.zshrc
	echo "ZSH_THEME=\"robbyrussell\"" >> /home/vagrant/.zshrc # change theme here 
	echo "plugins=(git sudo)" >> /home/vagrant/.zshrc # plugins
	echo "source /home/vagrant/.oh-my-zsh/oh-my-zsh.sh" >> /home/vagrant/.zshrc
	zsh
fi

chown -R vagrant /var/www/html
