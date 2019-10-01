#!/bin/bash

#This script requires sudo to work properly

#Downloading and installing Go lang necessary for building IPFS
snap install go --classic 	#requires sudo
export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:$GOPATH/bin
source $HOME/.profile

#installing git
apt install git 		#requires sudo

#Downloading and building IPFS
git clone https://github.com/ipfs/go-ipfs.git
cp -r go /usr/local/ 		#requires sudo
cp -r go-ipfs /usr/local/	#requires sudo	
cd go-ipfs
make install
