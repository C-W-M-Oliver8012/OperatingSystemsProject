#! /bin/bash

YELLOW="\033[1;38;5;136;48;5;234m"
GREEN="\033[1;38;5;34;48;5;234m"
WHITE="\033[0;38;5;253;48;5;234m"
BACKGROUND="\033[48;5;234m"
DEFAULT="\033[0m"

function print_menu_header
{
	clear
	printf "\n${YELLOW}   ===============================================\n"
	printf "   |  ${GREEN}%-20s : %-20s${YELLOW}|\n" "$1" "$2"
	printf "   ===============================================\n"
}

printf "${BACKGROUND}"

first_menu=1

if [[ ( -d "Financial_Files" && -d "General_Files" && -d "Project_Files" ) ]]; then
	while [[ ( "$2" == "power_user" && "$input" -ne 4 ) || ( "$2" == "general_user" && "$input" -ne 3 ) ]]; do
		if [ "$first_menu" -eq 1 ]; then
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
		fi

		if [ "$input" -eq 1 ]; then
			clear
			print_menu_header "$1" "$2"
			printf "   |  ${WHITE}General Files                              ${YELLOW}|\n"
			printf "   |                                             |\n"
			i=1
			for entry in "General_Files"/*; do
				IFS='/' read directory file <<< "$entry"
				printf "   | ${WHITE}%2d) %-39s ${YELLOW}|\n" "$i" "$file"
				i=$((i+1))
			done
			printf "   | ${WHITE}%2d) Exit                                    ${YELLOW}|\n" "$i"
			printf "   ===============================================\n\n"
			printf "${WHITE}   Option: "
			read input
			i=1
			for entry in "General_Files"/*; do
				echo "$entry"
				if [ "$input" == "$i" ]; then
					file_to_open="$entry"
				fi
				i=$((i+1))
			done
			clear
			if (( "$input" < "$i" )); then
				echo $file_to_open
				while read line; do
					echo "$line"
				done < "$file_to_open"
				read exit
			fi
			if [ "$input" == "$i" ]; then
				first_menu=1
				input=""
			else
				first_menu=0
				input=1
			fi
		elif [ "$input" -eq 2 ]; then
			clear
			print_menu_header "$1" "$2"
			printf "   |  ${WHITE}Project Files                              ${YELLOW}|\n"
			printf "   |                                             |\n"
			i=1
			for entry in "Project_Files"/*; do
				IFS='/' read directory file <<< "$entry"
				printf "   | ${WHITE}%2d) %-39s ${YELLOW}|\n" "$i" "$file"
				i=$((i+1))
			done
			printf "   ===============================================\n\n"
			printf "${WHITE}   Option: "
			read input
		elif [[ ( "$input" -eq 3 && "$2" == "power_user" ) ]]; then
			clear
			print_menu_header "$1" "$2"
			printf "   |  ${WHITE}Financial Files                            ${YELLOW}|\n"
			printf "   |                                             |\n"
			i=1
			for entry in "Financial_Files"/*; do
				IFS='/' read directory file <<< "$entry"
				printf "   | ${WHITE}%2d) %-39s ${YELLOW}|\n" "$i" "$file"
				i=$((i+1))
			done
			printf "   ===============================================\n\n"
			printf "${WHITE}   Option: "
			read input
		fi
	done
fi

printf "${DEFAULT}"
