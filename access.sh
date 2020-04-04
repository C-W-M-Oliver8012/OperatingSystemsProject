#! /bin/bash

YELLOW="\033[38;5;136m"
WHITE="\033[1;37m"

function print_menu_header 
{
	clear

	printf "\n${YELLOW}   ===============================================\n"
	printf "   | ${WHITE}Welcome to the Bash User Access System      ${YELLOW}|\n"
	printf "   ===============================================\n"
}

if [[ ( -d "Financial_Files" && -d "General_Files" && -d "Project_Files" ) ]]; then
	print_menu_header
	printf "   | ${WHITE}1) General Files                            ${YELLOW}|\n"
	printf "   | ${WHITE}2) Project Files                            ${YELLOW}|\n"
	
	if [ "$1" == "power_user" ]; then
		printf "   | ${WHITE}3) Financial Files                          ${YELLOW}|\n"
	fi
	
	printf "   ===============================================\n\n"
	printf "${WHITE}"
	read -p "   Directory to Open: " input
	
	if [ "$input" == 1 ]; then
		clear
		print_menu_header
		printf "   | ${WHITE}General Files                               ${YELLOW}|\n"
		printf "   ===============================================${WHITE}\n"
		for entry in "General_Files"/*; do
			printf "   $entry\n"
		done
	elif [ "$input" == 2 ]; then
		clear
		print_menu_header
		printf "   | ${WHITE}Project Files                               ${YELLOW}|\n"
		printf "   ===============================================${WHITE}\n"
		for entry in "Project_Files"/*; do
			printf "   $entry\n"
		done
	elif [[ ( "$input" == 3 && "$1" == "power_user" ) ]]; then
		clear
		print_menu_header
		printf "   | ${WHITE}Financial Files                             ${YELLOW}|\n"
		printf "   ===============================================${WHITE}\n"
		for entry in "Financial_Files"/*; do
			printf "   $entry\n"
		done
	fi
	
	printf "\n"
	read -p "   Press enter to return to menu..." input
fi


