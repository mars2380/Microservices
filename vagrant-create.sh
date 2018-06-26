#!/bin/bash
function CHECK_VAGRANT {
	VERSION=$(vagrant --version)
}
function CHECK_VIRTUALBOX {
	WHEREIS=$(whereis virtualbox | awk -F":" '{print $NF}')
}
function install_linux {
	CHECK_VAGRANT
	if [ ! -z "$VERSION" ]; then
		echo "Vagrant is installed"
		sleep 3
	else
		echo "NO"
		sudo apt update && sudo apt install vagrant -y
	fi
	CHECK_VIRTUALBOX
	if [ ! -z  "$WHEREIS" ]; then
		echo "VirtualBox is installed"
		sleep 3
	else
		echo "NO"
		sudo apt update && sudo apt install -y virtualbox virtualbox-qt virtualbox-guest-utils
	fi	
}

oscheck="$(uname)"
if [[ "$oscheck" == "Linux" ]]; then
	install_linux
else
	echo "No Linux or Apple"
fi

vagrant up $1
vagrant box update
vagrant provision $1
vagrant ssh $1
