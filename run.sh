#!/bin/bash
#

YELLOW="\033[1;33m"
BLUE="\033[1;34m"
PURPLE="\033[1;35m"
CYAN="\033[1;36m"
WHITE="\033[1;37m"
RESET="\033[0m"

cleanup()
{
    printf "\n\n${PURPLE}CTRL+C detected. Removing containters...${RESET}\n"
    docker-compose stop
    docker-compose rm -f

    printf "\n\n${PURPLE}Cleaning up complete.${RESET}\n"
    trap - INT
}
trap cleanup INT

docker-compose stop
docker-compose rm -f
docker-compose up --remove-orphans