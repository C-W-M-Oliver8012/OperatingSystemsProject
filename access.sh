#! /bin/bash

YELLOW="\033[1;38;5;136;48;5;234m"
GREEN="\033[1;38;5;34;48;5;234m"
WHITE="\033[0;38;5;253;48;5;234m"
BACKGROUND="\033[48;5;234m"
DEFAULT="\033[0m"

function print_menu_header
{
	clear
	printf "\n%b   ===============================================\n" "$YELLOW"
	printf "   |  %b%-20s : %-20s%b|\n" "$GREEN" "$1" "$2" "$YELLOW"
	printf "   ===============================================\n"
}

printf "%b" "$BACKGROUND"

first_menu=1
input=0

if [ -d "Financial_Files" ] && [ -d "General_Files" ] && [ -d "Project_Files" ]; then
	while [ "$2" == "power_user" ] && [ "$input" != 4 ] || [ "$2" == "general_user" ] && [ "$input" != 3 ]; do
		if [ "$first_menu" == 1 ]; then
			print_menu_header "$1" "$2"
			printf "   |  %bDirectory Options                          %b|\n" "$WHITE" "$YELLOW"
			printf "   |                                             |\n"
			printf "   |  %b1) General Files                           %b|\n" "$WHITE" "$YELLOW"
			printf "   |  %b2) Project Files                           %b|\n" "$WHITE" "$YELLOW"

			if [ "$2" == "power_user" ]; then
				printf "   |  %b3) Financial Files                         %b|\n" "$WHITE" "$YELLOW"
				printf "   |  %b4) Return to user menu                     %b|\n" "$WHITE" "$YELLOW"
			elif [ "$2" == "general_user" ]; then
				printf "   |  %b3) Return to user menu                     %b|\n" "$WHITE" "$YELLOW"
			fi

			printf "   ===============================================\n\n"
			printf "%b   Option: " "$WHITE"
			read -r input
		fi

		if [ "$input" == 1 ]; then
			clear
			print_menu_header "$1" "$2"
			printf "   |  %bGeneral Files                              %b|\n" "$WHITE" "$YELLOW"
			printf "   |                                             |\n"
			i=1
			for entry in "General_Files"/*; do
				IFS='/' read -r directory file <<< "$entry"
				printf "   | %b%2d) %-39s %b|\n" "$WHITE" "$i" "$file" "$YELLOW"
				i=$((i+1))
			done
			printf "   | %b%2d) Exit                                    %b|\n" "$WHITE" "$i" "$YELLOW"
			printf "   ===============================================\n\n"
			printf "%b   Option: " "$WHITE"
			read -r input
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
				echo "$file_to_open"
				while read -r line; do
					echo "$line"
				done < "$file_to_open"
				read -r exit
			fi
			if [ "$input" == "$i" ]; then
				first_menu=1
				input=0
			else
				first_menu=0
				input=1
			fi
		elif [ "$input" == 2 ]; then
			clear
			print_menu_header "$1" "$2"
			printf "   |  %bProject Files                              %b|\n" "$WHITE" "$YELLOW"
			printf "   |                                             |\n"
			i=1
			for entry in "Project_Files"/*; do
				IFS='/' read -r directory file <<< "$entry"
				printf "   | %b%2d) %-39s %b|\n" "$WHITE" "$i" "$file" "$YELLOW"
				i=$((i+1))
			done
			printf "   ===============================================\n\n"
			printf "%b   Option: " "$WHITE"
			read -r input
		elif [ "$input" == 3 ] && [ "$2" == "power_user" ]; then
			clear
			print_menu_header "$1" "$2"
			printf "   |  %bFinancial Files                            %b|\n" "$WHITE" "$YELLOW"
			printf "   |                                             |\n"
			i=1
			for entry in "Financial_Files"/*; do
				IFS='/' read -r directory file <<< "$entry"
				printf "   | %b%2d) %-39s %b|\n" "$WHITE" "$i" "$file" "$YELLOW"
				i=$((i+1))
			done
			printf "   ===============================================\n\n"
			printf "%b   Option: " "$WHITE"
			read -r input
		fi
	done
fi

printf "%b" "$DEFAULT"
