#!/bin/bash

command_exists() {
	command -v "$@" >/dev/null 2>&1
}

create_file() {
	if [ ! -f "$HOME/$1" ]; then
		touch "$HOME/$1"
	fi
}


