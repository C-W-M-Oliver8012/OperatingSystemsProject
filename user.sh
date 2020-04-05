#! /bin/bash

: '
This program controls the user menu once a user has logged in
'


: '
The following code are functions that will be used
in the main code below all of the functions.
'

YELLOW="\033[38;5;136m"
GREEN="\033[38;5;34m"
WHITE="\033[38;5;254m"
BACKGROUND="\033[48;5;234m"
DEFAULT="\033[0m"


function print_menu
{
	clear
	printf "\n${YELLOW}   ===============================================\n"
	printf "   |  ${GREEN}%-20s : %-20s${YELLOW}|\n" "$1" "$2"
	printf "   ===============================================\n"
	printf "   |  ${WHITE}1) Open a directory                        ${YELLOW}|\n"
	printf "   |  ${WHITE}2) Logout                                  ${YELLOW}|\n"
	printf "   ===============================================\n\n"
}


: '
The following code is what is actually running
for the program.
'

printf "${BACKGROUND}"

input=""

while [ "$input" != 2 ]; do

	print_menu "$1" "$2"
	printf "${WHITE}   Option: ${WHITE}"
	read input

	if [ "$input" == 1 ]; then
		./access.sh "$1" "$2"
		printf "${BACKGROUND}"
	fi
done

printf "${DEFAULT}"

