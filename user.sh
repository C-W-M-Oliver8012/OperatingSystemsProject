#! /bin/bash

: '
This program controls the user menu once a user has logged in
'


: '
The following code are functions that will be used
in the main code below all of the functions.
'

YELLOW="\033[38;5;136m"
WHITE="\033[1;37m"

function print_menu_header 
{
	clear

	printf "\n${YELLOW}   ===============================================\n"
	printf "   |  ${WHITE}Welcome to the Bash User Access System     ${YELLOW}|\n"
	printf "   ===============================================\n"
}

function print_menu
{
	printf "   |  ${WHITE}Hello %-36s ${YELLOW}|\n" "$1"
	printf "   |  ${WHITE}You are logged in as a %-19s ${YELLOW}|\n" "$2"
	printf "   |                                             |\n"
	printf "   |  ${WHITE}What would you like to do?                 ${YELLOW}|\n"
	printf "   ===============================================\n"
	printf "   |  ${WHITE}1) Open a directory                        ${YELLOW}|\n"
	printf "   |  ${WHITE}2) Log Out                                 ${YELLOW}|\n"
	printf "   ===============================================\n\n"
}


: '
The following code is what is actually running
for the program.
'

input=""

while [ "$input" != 2 ]; do

	print_menu_header
	print_menu "$1" "$2"
	printf "${WHITE}"
	read -p "   Option: " input

	if [ "$input" == 1 ]; then
		./access.sh "$1" "$2"
	fi
done


