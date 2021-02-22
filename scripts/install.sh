#!/bin/bash


# some stuff need to install

monkey_progs=(
	firefox 
	htop 
	adb
       	git
	zsh
	chromium-browser
	vim
	python
	tree
)
sudo apt update && sudo apt upgrade && sudo apt install $monkey_progs
unset monkey_progs

create_file() {
	if [ ! -f "$HOME/$1" ]; then
		touch "$HOME/$1"
	fi
}

# create dotfiles if not exists
create_file .zshrc

unset create_file

# symlinks
ln -s ~/dot-monkey/.zshrc ~/.zshrc


echo "So, i setup everything.\n You must switch shell to zsh, but anyway i will ask for your permission."
read -p "Switch shell to zsh [Y, n]:" input
if [[ $input == "Y" || $input == "y" ]]; then
	chsh --shell="/usr/bin/zsh"
fi

echo "Enjoy my shitty setup"
