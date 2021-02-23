#!/bin/bash

set -e

SHELL_DES=/bin/zsh
DOT_ROOT=~/dot-files
REPO="AlecBold/dot-files"
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

command_exists() {
	command -v "$@" >/dev/null 2>&1
}

create_file() {
	if [ ! -f "$HOME/$1" ]; then
		touch "$HOME/$1"
	fi
}

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

	echo "Will install -> (${apt_progs[@]})"
	read -p "Install? [Y, n]: " input
	if [[ $input == "y" || $input == "Y" ]]; then
		echo "running [apt-get install]. It take some time..."
		for prog in "${apt_progs[@]}"; do
			if ! command_exists ${prog}; then
				echo "${YELLOW}[${prog}]${RESET} installing..."
				sudo apt-get -qq -y install ${prog} || {
					echo "${RED}[${prog}] failed${RESET}"
				}
			else
				echo "${BLUE}[${prog}]${RESET} already exist"
			fi
		done
	fi
	echo "finished"
}

configure_symlinks() {
	symlink_files=(
		.zshrc
	       	.gitconfig
	)
	for file in "${symlink_files[@]}"; do
		if [ -f "~/${file}" ]; then
			echo "${YELLOW}~/${file} already exist, cant create symlink"
		else
			ln -s $DOT_ROOT/${file} "~/${file}"
			echo "${GREEN}${DOT_ROOT}/${file} -> ~/${file}"
		fi
	done
}

switch_shell() {
	if ! command_exists zsh; then 
		echo "${RED}first need to install zsh to continue${RESET}"
		exit 1
	fi

	if ! chsh -s $SHELL_DES; then
		echo "${RED}chsh was unsuccessful${RESET}"
	else
		export SHELL=$SHELL_DES
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

main() {
	setup_color

	install_repo
	install_apt_programs

	configure_symlinks
	switch_shell

cat <<"EOF"
 _       __     __                             ______         ________
| |     / /__  / /________  ____ ___  ___     /_  __/___     /_  __/ /_  ___
| | /| / / _ \/ / ___/ __ \/ __ `__ \/ _ \     / / / __ \     / / / __ \/ _ \
| |/ |/ /  __/ / /__/ /_/ / / / / / /  __/    / / / /_/ /    / / / / / /  __/
|__/|__/\___/_/\___/\____/_/ /_/ /_/\___/    /_/  \____/    /_/ /_/ /_/\___/

    ____  _              _______      __    __
   / __ \(_)_______     / ____(_)__  / /___/ /____
  / /_/ / / ___/ _ \   / /_  / / _ \/ / __  / ___/
 / _, _/ / /__/  __/  / __/ / /  __/ / /_/ (__  )
/_/ |_/_/\___/\___/  /_/   /_/\___/_/\__,_/____/

    __  ___      __  __              ____           __
   /  |/  /___  / /_/ /_  ___  _____/ __/_  _______/ /_____  _____
  / /|_/ / __ \/ __/ __ \/ _ \/ ___/ /_/ / / / ___/ //_/ _ \/ ___/
 / /  / / /_/ / /_/ / / /  __/ /  / __/ /_/ / /__/ ,< /  __/ /
/_/  /_/\____/\__/_/ /_/\___/_/  /_/  \__,_/\___/_/|_|\___/_/

EOF
	exec zsh -l
}


main "$@"
