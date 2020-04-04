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
	printf "   | ${WHITE}Welcome to the Bash User Access System      ${YELLOW}|\n"
	printf "   ===============================================\n"
}

function print_menu
{
	printf "   | ${WHITE}You have successfully logged in!            ${YELLOW}|\n"
	printf "   | ${WHITE}Unfortunately there are no supported        ${YELLOW}|\n"
	printf "   | ${WHITE}options at the moment. Press enter to       ${YELLOW}|\n"
	printf "   | ${WHITE}return to loggin screen.                    ${YELLOW}|\n"
	printf "   ===============================================\n\n"
}


: '
The following code is what is actually running
for the program.
'

print_menu_header
print_menu
printf "${WHITE}"
read -p "   Press enter..."
