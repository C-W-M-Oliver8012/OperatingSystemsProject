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

function print_directories_and_get_input_option
{
	if [ "$first_menu" = 1 ]; then
		print_menu_header "$1" "$2"
		printf "   |  %bDirectory Options                          %b|\n" "$WHITE" "$YELLOW"
		printf "   |                                             |\n"
		printf "   |  %b1) General Files                           %b|\n" "$WHITE" "$YELLOW"
		printf "   |  %b2) Project Files                           %b|\n" "$WHITE" "$YELLOW"

		if [ "$2" = "power_user" ]; then
			printf "   |  %b3) Financial Files                         %b|\n" "$WHITE" "$YELLOW"
			printf "   |  %b4) Return to user menu                     %b|\n" "$WHITE" "$YELLOW"
		elif [ "$2" = "general_user" ]; then
			printf "   |  %b3) Return to user menu                     %b|\n" "$WHITE" "$YELLOW"
		fi

		printf "   ===============================================\n\n"
		printf "%b   Option: " "$WHITE"
		read -r directory_option

		if [ "$2" = "power_user" ] && [ "$directory_option" == 4 ]; then
			loop_option=1
		elif [ "$2" = "general_user" ] && [ "$directory_option" == 3 ]; then
			loop_option=1
		fi
	fi
}

function display_and_get_file_to_open
{
	clear
	print_menu_header "$1" "$2"
	printf "   |  %b%-20s                       %b|\n" "$WHITE" "$3" "$YELLOW"
	printf "   |                                             |\n"
	i=1
	for entry in "$3"/*; do
		IFS='/' read -r directory file <<< "$entry"
		printf "   | %b%2d) %-39s %b|\n" "$WHITE" "$i" "$file" "$YELLOW"
		i=$((i+1))
	done
	printf "   | %b%2d) Exit                                    %b|\n" "$WHITE" "$i" "$YELLOW"
	printf "   ===============================================\n\n"
	printf "%b   Option: " "$WHITE"
	read -r file_option
}

function display_file_contents
{
	i=1
	for entry in "$1"/*; do
		echo "$entry"
		if [ "$file_option" = "$i" ]; then
			file_to_open="$entry"
		fi
		i=$((i+1))
	done
	clear
	if (( "$file_option" < "$i" )) && (( "$file_option" > 0 )); then
		printf "%b" "$GREEN"
		printf "\n   %s\n\n" "$file_to_open"
		y=1
		while read -r line; do
			printf "%b%4d%b|%b %s\n" "$GREEN" "$y" "$YELLOW" "$WHITE" "$line"
			y=$((y+1))
		done < "$file_to_open"
		read -r exit
	fi
	if [ "$file_option" = "$i" ]; then
		first_menu=1
		directory_option=0
	else
		first_menu=0
		directory_option="$2"
	fi
}

printf "%b" "$BACKGROUND"

first_menu=1
directory_option=0
loop_option=0
file_option=0

if [ -d "Financial_Files" ] && [ -d "General_Files" ] && [ -d "Project_Files" ]; then
	while [ "$loop_option" = 0 ]; do
		print_directories_and_get_input_option "$1" "$2"

		if [ "$directory_option" = 1 ]; then
			display_and_get_file_to_open "$1" "$2" "General_Files"
			display_file_contents "General_Files" "1"
		elif [ "$directory_option" = 2 ]; then
			display_and_get_file_to_open "$1" "$2" "Project_Files"
			display_file_contents "Project_Files" "2"
		elif [ "$directory_option" = 3 ] && [ "$2" = "power_user" ]; then
			display_and_get_file_to_open "$1" "$2" "Financial_Files"
			display_file_contents "Financial_Files" "3"
		fi
	done
fi

printf "%b" "$DEFAULT"
