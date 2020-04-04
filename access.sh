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

	while [[ ( "$1" == "power_user" && "$input" != 4 ) || ( "$1" == "general_user" && "$input" != 3 ) ]]; do
		
		print_menu_header
		printf "   | ${WHITE}1) General Files                            ${YELLOW}|\n"
		printf "   | ${WHITE}2) Project Files                            ${YELLOW}|\n"
		
		if [ "$1" == "power_user" ]; then
			printf "   | ${WHITE}3) Financial Files                          ${YELLOW}|\n"
			printf "   | ${WHITE}4) Return to user menu                      ${YELLOW}|\n"
		elif [ "$1" == "general_user" ]; then
			printf "   | ${WHITE}3) Return to user menu                      ${YELLOW}|\n"
		fi
		
		printf "   ===============================================\n\n"
		printf "${WHITE}"
		read -p "   Directory to Open: " input
		
		if [ "$input" == 1 ]; then
			clear
			print_menu_header
			printf "   | ${WHITE}General Files                               ${YELLOW}|\n"
			printf "   ===============================================\n"
			i=1
			for entry in "General_Files"/*; do
				printf "   | ${WHITE}%2d) %-39s ${YELLOW}|\n" "$i" "$entry"
				i=$((i+1))
			done
			printf "   ===============================================\n"
			
		elif [ "$input" == 2 ]; then
			clear
			print_menu_header
			printf "   | ${WHITE}Project Files                               ${YELLOW}|\n"
			printf "   ===============================================\n"
			i=1
			for entry in "Project_Files"/*; do
				printf "   | ${WHITE}%2d) %-39s ${YELLOW}|\n" "$i" "$entry"
				i=$((i+1))
			done
			printf "   ===============================================\n"
			
		elif [[ ( "$input" == 3 && "$1" == "power_user" ) ]]; then
			clear
			print_menu_header
			printf "   | ${WHITE}Financial Files                             ${YELLOW}|\n"
			printf "   ===============================================\n"
			i=1
			for entry in "Financial_Files"/*; do
				printf "   | ${WHITE}%2d) %-39s ${YELLOW}|\n" "$i" "$entry"
				i=$((i+1))
			done
			printf "   ===============================================\n"
		fi
		
		if [ "$input" != 4 ]; then
			printf "${WHITE}\n"
			read -p "   Press enter to return to menu..." input
		fi
		
	done

fi


