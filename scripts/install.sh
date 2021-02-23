#!/bin/bash

set -e

DOT_ROOT="~/dot-files"
REPO="AlecBold/dot-files"
BRANCH="master"
REMOTE="https://github.com/${REPO}"

apt_progs=(
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


setup_color() {
	# Only use colors if connected to a terminal
	if [ -t 1 ]; then
		RED=$(printf '\033[31m')
		GREEN=$(printf '\033[32m')
		YELLOW=$(printf '\033[33m')
		BLUE=$(printf '\033[34m')
		BOLD=$(printf '\033[1m')
		RESET=$(printf '\033[m')
	else
		RED=""
		GREEN=""
		YELLOW=""
		BLUE=""
		BOLD=""
		RESET=""
	fi
}

install_apt_programs() {
	if ! command_exists apt-get; then
		cat <<EOF
I cant install programs. You need to install apt-get for that.
EOF
		return
	fi
	echo "running [apt-get update && apt-get upgrade]..."
	sudo apt-get -qq update && sudo apt-get -qq -y upgrade
	echo "finished"

	read -p "Install -> [${apt_progs}]? [Y, n]: " input
	if [ $input == "y" || $input == "n" ]; then
		echo "running [apt-get install]. It take some time..."
		for prog ($apt_progs); do
			if ! command_exists ${prog}; then
				echo "${YELLOW}[${prog}]${RESET} installing..."
				sudo apt-get -qq -y install ${prog} || {
					echo "${RED}[${prog}] failed${RESET}"
				}
			else
				echo "${BLUE}[${prog}]${RESET} already exist"
			fi
		done
		echo "finished"
	fi
}

configure_symlinks() {
	if [ -f ~/.zshrc ]; then
		echo "${YELLOW}~/.zshrc already exist, cant create symlink${RESET}"
		read -p "Continue? [y, n]: " input
		if [ $input != "y" && $input != "Y" ]; then
			exit 1
		fi
	else
		ln -s $DOT_ROOT/.zshrc ~/.zshrc
	fi
}

switch_shell() {
	if ! command_exists zsh; then 
		echo "${RED}first need to install zsh to continue${RESET}"
		exit 1
	fi

	if ! chsh -s "/usr/bin/zsh"; then
		echo "${RED}chsh was unsuccessful${RESET}"
	else
		export SHELL="/usr/bin/zsh"
		echo "${GREEN}shell succesfully changed to zsh${RESET}"
	fi
}

install_repo() {
	if ! command_exists git; then
		echo "${RED}first need to install git to continue${RESET}"
		exit 1
	fi
	git clone "${REMOTE}" "${DOT_ROOT}" || {
		echo "${RED}git clone failed${RESET}"
		exit 1
	}
}

run_others_sh() {
	${DOT_ROOT}/scripts/funcs.sh
}

main() {
	setup_color

	install_repo
	run_others_sh

	install_apt_programs

	configure_symlinks
	switch_shell


	ricefields="
			 _      ________   _________  __  _______
			| | /| / / __/ /  / ___/ __ \/  |/  / __/
			| |/ |/ / _// /__/ /__/ /_/ / /|_/ / _/  
			|__/|__/___/____/\___/\____/_/  /_/___/  
			__________        ________ ______
			/_  __/ __ \	 /_  __/ // / __/
			 / / / /_/ /	  / / / _  / _/  
			/_/  \____/	 /_/ /_//_/___/  
		   ___  ___________________________   ___  ____
		  / _ \/  _/ ___/ __/ __/  _/ __/ /  / _ \/ __/
		 / , _// // /__/ _// _/_/ // _// /__/ // /\ \
		/_/|_/___/\___/___/_/ /___/___/____/____/___/ 
	    __  _______  ________ _________  ______  _________ _________
	  /  |/  / __ \/_  __/ // / __/ _ \/ __/ / / / ___/ //_/ __/ _ \
	 / /|_/ / /_/ / / / / _  / _// , _/ _// /_/ / /__/ ,< / _// , _/
	/_/  /_/\____/ /_/ /_//_/___/_/|_/_/  \____/\___/_/|_/___/_/|_|

	"
	echo $ricefields
	exec zsh -l
}


main "$@"
