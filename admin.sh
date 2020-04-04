#! /bin/bash

: '
This program controls the functionality of the admin
'


: '
The following code are functions that will be used
in the main code below all of the functions.
'

YELLOW="\033[1;33m"
WHITE="\033[1;37m"

function check_for_and_create_directories
{
	if [ ! -d "General_Files" ]; then
		mkdir General_Files
		> General_Files/test.txt
		> General_Files/test1.txt
		> General_Files/test2.txt
	fi

	if [ ! -d "Project_Files" ]; then
		mkdir Project_Files
		> Project_Files/test.txt
		> Project_Files/test1.txt
		> Project_Files/test2.txt
	fi

	if [ ! -d "Financial_Files" ]; then
		mkdir Financial_Files
		> Financial_Files/test.txt
		> Financial_Files/test1.txt
		> Financial_Files/test2.txt
	fi

	if [ ! -f "users.txt" ]; then
		> users.txt
		echo "admin-power_user-buasa" > users.txt
	fi
}

function print_menu_header 
{
	clear

	printf "\n${YELLOW}   ===============================================\n"
	printf "   | ${WHITE}Welcome to the Bash User Access System      ${YELLOW}|\n"
	printf "   ===============================================\n"
}

function print_main_menu
{
	printf "   | ${WHITE}You are admin: choose an option             ${YELLOW}|\n"
	printf "   |                                             |\n"
	printf "   | ${WHITE}1) Create a new Power User                  ${YELLOW}|\n"
	printf "   | ${WHITE}2) Create a new General User                ${YELLOW}|\n"
	printf "   | ${WHITE}3) List Users                               ${YELLOW}|\n"
	printf "   | ${WHITE}4) Delete Users                             ${YELLOW}|\n"
	printf "   | ${WHITE}5) Open a Directory                         ${YELLOW}|\n"
	printf "   | ${WHITE}6) Log Out                                  ${YELLOW}|\n"
	printf "   ===============================================\n\n"
}

function prompt_admin_to_change_password
{
	while [[ ( $input != 1 && $input != 2 ) ]]; do

		print_menu_header
		printf "   | ${WHITE}You are logged in as admin. The default     ${YELLOW}|\n"
		printf "   | ${WHITE}password is 'buasa'. Press 1 to change the  ${YELLOW}|\n"
		printf "   | ${WHITE}password and 2 to quit the program.         ${YELLOW}|\n"
		printf "   ===============================================\n\n"

		printf "${WHITE}"
		read -p "   Option: " input
	done
}

function get_new_password_for_admin
{
	if [ $input == 1 ]; then

		print_menu_header
		printf "   | ${WHITE}Please enter a new password!                ${YELLOW}|\n"
		printf "   ===============================================\n\n"
		printf "${WHITE}"
		read -s -p "   New Password: " password
		echo "admin-power_user-$password" > users.txt
	fi
}

function init_admin
{
	input=0
	current_password=$(head -n 1 "users.txt")

	if [ "$current_password" == "admin-power_user-buasa" ]; then

		prompt_admin_to_change_password
		password="buasa"

		get_new_password_for_admin
	fi
}

function create_power_user
{
	print_menu_header
	printf "   | ${WHITE}Enter Credentials for new Power User        ${YELLOW}|\n"
	printf "   ===============================================\n\n"
	printf "${WHITE}"
	read -p "   Username: " name
	read -s -p "   Password: " password
	echo "$name-power_user-$password" >> users.txt
}

function create_general_user
{
	print_menu_header
	printf "   | ${WHITE}Enter Credentials for new General User      ${YELLOW}|\n"
	printf "   ===============================================\n\n"
	printf "${WHITE}"
	read -p "   Username: " name
	read -s -p "   Password: " password
	echo "$name-general_user-$password" >> users.txt
}

function list_users_and_types
{
	print_menu_header
		
	i=1
	while IFS='-' read user access pass; do
		printf "   | ${WHITE}%2d) %-15s  - %-12s         ${YELLOW}|\n" $i $user $access
		i=$((i+1))
	done < users.txt
	
	printf "   ===============================================\n\n"
	printf "${WHITE}"
	read -p "   Press enter to continue..." input
}

function delete_user
{
	print_menu_header
	printf "   | ${WHITE}Select user to delete                       ${YELLOW}|\n"
	printf "   |                                             |\n"
	
	i=1
	while IFS='-' read user access pass; do
		printf "   | ${WHITE}%2d) %-15s  - %-12s         ${YELLOW}|\n" $i $user $access
		i=$((i+1))
	done < users.txt
	
	printf "   ===============================================\n\n"
	printf "${WHITE}"
	read -p "   User to delete: " input
	
	if [ $input != 1 ]; then
		i=1
		while read line; do
			if [ $input != $i ]; then
				echo $line >> tmp_users.txt
			fi
			i=$((i+1))
		done < users.txt
	
		rm users.txt
		while read line; do
			echo $line >> users.txt
		done < tmp_users.txt
	
		rm tmp_users.txt
	fi
}


: '
The following code is what is actually running
for the program.
'

check_for_and_create_directories
init_admin

input=0
current_password=$(head -n 1 "users.txt")
name=""
password=""

while [[ ( $input != 6 && "$current_password" != "admin-power_user-buasa" ) ]]; do

	print_menu_header
	print_main_menu
	printf "${WHITE}"
	read -p "   Option: " input

	if [ "$input" == 1 ]; then
		create_power_user
		
	elif [ "$input" == 2 ]; then
		create_general_user
		
	elif [ "$input" == 3 ]; then
		list_users_and_types
		
	elif [ "$input" == 4 ]; then
		delete_user
	
	elif [ "$input" == 5 ]; then
		./access.sh power_user
	fi
done

