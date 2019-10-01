#!/bin/bash

#Downloading and isntalling Go lang necessary for building IPFS
sudo snap install go --classic 	#requires sudo
export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:$GOPATH/bin
source $HOME/.profile

#isntalling git
sudo apt install git 		#requires sudo

#Downloading and building IPFS
git clone https://github.com/ipfs/go-ipfs.git
cd go-ipfs
make install
