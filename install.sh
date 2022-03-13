#!/bin/bash

chmod +x tedit

[ ! -d "$HOME/.bin" ] && mkdir "$HOME/.bin"

cp tedit $HOME/.bin

export PATH=$PATH:$HOME/.bin

if [[ "$SHELL" == "/bin/bash" ]] || [[ "$SHELL" == "/usr/bin/bash" ]]; then
	echo "export PATH=$PATH:~/.bin" >> ~/.bashrc 
elif [[ "$SHELL" = "/bin/zsh" ]] || [[ "SHELL" == "/usr/bin/zsh" ]]; then
	echo "export PATH=$PATH:~/.bin" >> ~/.zshrc
fi

