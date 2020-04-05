#! /bin/bash

YELLOW="\033[1;38;5;136m"
GREEN="\033[38;5;34m"
WHITE="\033[0m"
DEFAULT="\033[0m"

function print_menu_header 
{
	clear

	printf "\n${YELLOW}   ===============================================\n"
	printf "   |  ${GREEN}%-20s : %-20s${YELLOW}|\n" "$1" "$2"
	printf "   ===============================================\n"
}


if [[ ( -d "Financial_Files" && -d "General_Files" && -d "Project_Files" ) ]]; then

	while [[ ( "$2" == "power_user" && "$input" != 4 ) || ( "$2" == "general_user" && "$input" != 3 ) ]]; do
		
		print_menu_header "$1" "$2"
		printf "   |  ${WHITE}Directory Options                          ${YELLOW}|\n"
		printf "   |                                             |\n"
		printf "   |  ${WHITE}1) General Files                           ${YELLOW}|\n"
		printf "   |  ${WHITE}2) Project Files                           ${YELLOW}|\n"
		
		if [ "$2" == "power_user" ]; then
			printf "   |  ${WHITE}3) Financial Files                         ${YELLOW}|\n"
			printf "   |  ${WHITE}4) Return to user menu                     ${YELLOW}|\n"
		elif [ "$2" == "general_user" ]; then
			printf "   |  ${WHITE}3) Return to user menu                     ${YELLOW}|\n"
		fi
		
		printf "   ===============================================\n\n"
		printf "${WHITE}   Option: ${WHITE}"
		read input
		
		if [ "$input" == 1 ]; then
			clear
			print_menu_header "$1" "$2"
			printf "   |  ${WHITE}General Files                              ${YELLOW}|\n"
			printf "   |                                             |\n"
			i=1
			for entry in "General_Files"/*; do
				printf "   | ${WHITE}%2d) %-39s ${YELLOW}|\n" "$i" "$entry"
				i=$((i+1))
			done
			printf "   ===============================================\n"
			
		elif [ "$input" == 2 ]; then
			clear
			print_menu_header "$1" "$2"
			printf "   |  ${WHITE}Project Files                              ${YELLOW}|\n"
			printf "   |                                             |\n"
			i=1
			for entry in "Project_Files"/*; do
				printf "   | ${WHITE}%2d) %-39s ${YELLOW}|\n" "$i" "$entry"
				i=$((i+1))
			done
			printf "   ===============================================\n"
			
		elif [[ ( "$input" == 3 && "$2" == "power_user" ) ]]; then
			clear
			print_menu_header "$1" "$2"
			printf "   |  ${WHITE}Financial Files                            ${YELLOW}|\n"
			printf "   |                                             |\n"
			i=1
			for entry in "Financial_Files"/*; do
				printf "   | ${WHITE}%2d) %-39s ${YELLOW}|\n" "$i" "$entry"
				i=$((i+1))
			done
			printf "   ===============================================\n"
		fi
		
		if [[ ( "$input" == 1 || "$input" == 2 ) || ( "$input" == 3 && "$2" == "power_user" ) ]]; then
			printf "\n${WHITE}   Press enter to return to menu...${WHITE}"
			read input
		fi
		
	done

fi

printf "${DEFAULT}"


