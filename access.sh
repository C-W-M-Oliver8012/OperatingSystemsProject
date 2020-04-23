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

function file_options_for_power_user
{
	printf "   ===============================================\n\n"
	printf "   1) Create file     2) Delete file     3) 0pen file\n"
	printf "   4) Exit\n"
	printf "%b   Option: " "$WHITE"
	read -r file_option

	if [ "$file_option" = 1 ]; then
		printf "   New file name: "
		read -r filename
		if [ ! -f "$directory/$filename" ]; then
			touch "$directory/$filename"
		fi
	elif [ "$file_option" = 2 ]; then
		printf "   File number above to delete: "
		read -r number
		num_files=1
		for entry in "$1"/*; do
			if [ "$number" = "$num_files" ]; then
				rm "$entry"
			fi
			num_files=$((num_files+1))
		done
	elif [ "$file_option" = 3 ]; then
		printf "   File number above to open: "
		read -r file_to_open_number
		file_loop=0
	elif [ "$file_option" = 4 ]; then
		file_loop=0
		file_option=4
	fi
}

function file_options_for_general_users
{
	printf "   ===============================================\n\n"
	printf "   1) Create file     2) 0pen file     3) Exit\n"
	printf "%b   Option: " "$WHITE"
	read -r file_option

	if [ "$file_option" = 1 ]; then
		printf "   New file name: "
		read -r filename
		if [ ! -f "$directory/$filename" ]; then
			touch "$directory/$filename"
		fi
	elif [ "$file_option" = 2 ]; then
		printf "   File number above to open: "
		read -r file_to_open_number
		file_loop=0
	elif [ "$file_option" = 3 ]; then
		file_loop=0
		file_option=4
	fi
}

# list the files in directory
function display_and_get_file_to_open
{
	file_loop=1
	while [ "$file_loop" = 1 ]; do
		clear
		print_menu_header "$1" "$2"
		printf "   |  %b%-20s                       %b|\n" "$WHITE" "$3" "$YELLOW"
		printf "   |                                             |\n"
		num_files=1
		for entry in "$3"/*; do
			IFS='/' read -r directory file <<< "$entry"
			printf "   | %b%2d| %-39s %b|\n" "$WHITE" "$num_files" "$file" "$YELLOW"
			num_files=$((num_files+1))
		done
		if [ "$2" = "power_user" ]; then
			file_options_for_power_user "$3"
		else
			file_options_for_general_users
		fi
	done
}

function append_line
{
	y=1
	while read -r line; do
		if [ "$3" = "$y" ]; then
			echo "$2" >> tmp_file.txt
		fi
		echo "$line" >> tmp_file.txt
		y=$((y+1))
	done < "$1"
	# append to end of file
	if [ "$3" = "$y" ]; then
		echo "$2" >> tmp_file.txt
	fi
	# append to beginning of file
	if [ "$y" = 1 ]; then
		echo "$2" >> tmp_file.txt
	fi

	rm "$1"
	touch "$1"
	while read -r line; do
		echo "$line" >> "$1"
	done < tmp_file.txt
	rm tmp_file.txt
}

function delete_line
{
	y=1
	while read -r line; do
		if [ "$2" != "$y" ]; then
			echo "$line" >> tmp_file.txt
		fi
		y=$((y+1))
	done < "$1"

	rm "$1"
	touch "$1"
	while read -r line; do
		echo "$line" >> "$1"
	done < tmp_file.txt
	rm tmp_file.txt
}

# prints all of the text editor options
function print_file_edit_options
{
	clear
	if [ "$file_option" != 4 ]; then
		printf "%b" "$GREEN"
		printf "\n   %s\n\n" "$file_to_open"
		y=1
		while read -r line; do
			printf "%b%4d%b|%b %s\n" "$GREEN" "$y" "$YELLOW" "$WHITE" "$line"
			y=$((y+1))
		done < "$file_to_open"
		if [ "$1" = "power_user" ]; then
			printf "\n\n%b   1) Append line     2) Delete line     3) Exit\n" "$YELLOW"
			printf "%b   Option: " "$WHITE"
			read -r edit_option
		else
			printf "\n\n   Press enter to continue..."
			read -r edit_option
			edit_option=3
		fi
	fi
}

# performs action in text editor
function perform_file_edit_options
{
	if [ "$edit_option" = 1 ]; then
		printf "   Line contents: "
		read -r line_contents
		printf "   Line number to append to: "
		read -r line_number
		if [ -n "$edit_option" ] && [ -n "$line_contents" ] && [ -n "$line_number" ]; then
			append_line "$file_to_open" "$line_contents" "$line_number"
		fi
	elif [ "$edit_option" = 2 ]; then
		printf "   Line to delete: "
		read -r line_number
		if [ -n "$edit_option" ] && [ -n "$line_number" ]; then
			delete_line "$file_to_open" "$line_number"
		fi
	elif [ "$edit_option" = 3 ]; then
		if [ "$file_option" = 4 ]; then
			first_menu=1
			directory_option=0
		else
			first_menu=0
			directory_option="$1"
		fi
		display_contents=0
	fi
}

# This is the code controlling the text editor
function display_file_contents
{
	edit_option=3
	display_contents=1
	while [ "$display_contents" = 1 ]; do
		num_files=1
		for entry in "$1"/*; do
			echo "$entry"
			if [ "$file_to_open_number" = "$num_files" ]; then
				file_to_open="$entry"
			fi
			num_files=$((num_files+1))
		done
		print_file_edit_options "$3"
		perform_file_edit_options "$2"
	done
}

printf "%b" "$BACKGROUND"

first_menu=1
directory_option=0
loop_option=0
file_option=0
edit_option=0

if [ -d "Financial_Files" ] && [ -d "General_Files" ] && [ -d "Project_Files" ]; then
	while [ "$loop_option" = 0 ]; do
		print_directories_and_get_input_option "$1" "$2"

		if [ "$directory_option" = 1 ]; then
			display_and_get_file_to_open "$1" "$2" "General_Files"
			display_file_contents "General_Files" "1" "$2"
		elif [ "$directory_option" = 2 ]; then
			display_and_get_file_to_open "$1" "$2" "Project_Files"
			display_file_contents "Project_Files" "2" "$2"
		elif [ "$directory_option" = 3 ] && [ "$2" = "power_user" ]; then
			display_and_get_file_to_open "$1" "$2" "Financial_Files"
			display_file_contents "Financial_Files" "3" "$2"
		fi
	done
fi

printf "%b" "$DEFAULT"
