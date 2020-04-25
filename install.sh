#!/bin/bash

chmod +x tedit

[ ! -d "$HOME/.bin" ] && mkdir "$HOME/.bin"

cp tedit $HOME/.bin

export PATH=$PATH:~/.bin

if [[ "$SHELL" == "/bin/bash" ]]; then
	
	echo "export PATH=$PATH:~/.bin" >> ~/.bashrc
elif [[ "$SHELL" = "/bin/zsh" ]]; then
	echo "export PATH=$PATH:~/.bin" >> ~/.zshrc
fi 
