#!/bin/bash

RED="\033[1;31m"
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
BLUE="\033[1;34m"
PURPLE="\033[1;35m"
CYAN="\033[1;36m"
WHITE="\033[1;37m"
RESET="\033[0m"

exit_if_error() {
	if [ $(($(echo "${PIPESTATUS[@]}" | tr -s ' ' +))) -ne 0 ]; then
		if [ ! -z "$1" ];
		then
			echo ""
			echo -e "${RED}ERROR: ${1}$RESET"
			echo ""
		fi
		exit 1
	fi
}

exit_with_error() {
	echo ""
	echo -e "${RED}ERROR: ${1}$RESET"
	echo ""
	exit 1
}

msg() {
	printf "\n${BLUE}$1${RESET}"
}

option() {
	printf "\n${WHITE}$1 - ${BLUE}$2${RESET}"
}

trace() {
	printf "\n\n${CYAN}$1${RESET}\n"
}

warn() {
	printf "\n\n${YELLOW}$1${RESET}\n\n"
}
