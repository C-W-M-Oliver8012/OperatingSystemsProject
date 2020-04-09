#! /bin/bash

: '
This program controls the functionality of the admin
'


: '
The following code are functions that will be used
in the main code below all of the functions.
'

YELLOW="\033[1;38;5;136;48;5;234m"
GREEN="\033[1;38;5;34;48;5;234m"
WHITE="\033[0;38;5;253;48;5;234m"
BACKGROUND="\033[48;5;234m"
DEFAULT="\033[0m"

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
		echo "admin-power_user-buasa-buasa" > users.txt
	fi
}

function print_menu_header
{
	clear
	printf "\n${YELLOW}   ===============================================\n"
	printf "   |  ${GREEN}admin                                      ${YELLOW}|\n"
	printf "   ===============================================\n"
}

function print_main_menu
{
	printf "   |  ${WHITE}1) Create a new Power User                 ${YELLOW}|\n"
	printf "   |  ${WHITE}2) Create a new General User               ${YELLOW}|\n"
	printf "   |  ${WHITE}3) List Users                              ${YELLOW}|\n"
	printf "   |  ${WHITE}4) Delete Users                            ${YELLOW}|\n"
	printf "   |  ${WHITE}5) Open a Directory                        ${YELLOW}|\n"
	printf "   |  ${WHITE}6) Logout                                  ${YELLOW}|\n"
	printf "   ===============================================\n\n"
}

function prompt_admin_to_change_password
{
	while [[ ( "$input" != 1 && "$input" != 2 ) ]]; do
		print_menu_header
		printf "   |  ${WHITE}Because you are the first user of the      ${YELLOW}|\n"
		printf "   |  ${WHITE}program, you are logged in as admin. The   ${YELLOW}|\n"
		printf "   |  ${WHITE}default password is 'buasa'. Press 1 to    ${YELLOW}|\n"
		printf "   |  ${WHITE}change the password and 2 to logout.       ${YELLOW}|\n"
		printf "   ===============================================\n\n"

		printf "${WHITE}   Option: ${WHITE}"
		read input
	done
}

function get_new_password_for_admin
{
	if [ "$input" == 1 ]; then
		print_menu_header
		printf "   |  ${WHITE}Please enter a new password!               ${YELLOW}|\n"
		printf "   ===============================================\n\n"
		printf "${WHITE}   New Password: ${WHITE}"
		read -s password
		echo "admin-power_user-$password-buasa" > users.txt
	fi
}

function init_admin
{
	input=0
	current_password=$(head -n 1 "users.txt")

	if [ "$current_password" == "admin-power_user-buasa-buasa" ]; then
		while [ -z "$password" ]; do
			prompt_admin_to_change_password
			get_new_password_for_admin
		done
	fi
}

function create_power_user
{
	print_menu_header
	printf "   |  ${WHITE}Enter Credentials for new Power User       ${YELLOW}|\n"
	printf "   ===============================================\n\n"
	printf "${WHITE}   Username: ${WHITE}"
	read name
	printf "${WHITE}   Password: ${WHITE}"
	read -s password

	matched=0
	while IFS='-' read user access pass default_pass; do
		if [[ ( "$name" == "$user" || -z "$name" || -z "$pass" ) ]]; then
			matched=1
		fi
	done < users.txt

	if [ "$matched" != 1 ]; then
		echo "$name-power_user-$password-$password" >> users.txt
	fi
}

function create_general_user
{
	print_menu_header
	printf "   |  ${WHITE}Enter Credentials for new General User     ${YELLOW}|\n"
	printf "   ===============================================\n\n"
	printf "${WHITE}   Username: ${WHITE}"
	read name
	printf "${WHITE}   Password: ${WHITE}"
	read -s password

	matched=0
	while IFS='-' read user access pass default_pass; do
		if [[ ( "$name" == "$user" || -z "$name" || -z "$pass" ) ]]; then
			matched=1
		fi
	done < users.txt

	if [ "$matched" != 1 ]; then
		echo "$name-general_user-$password-$password" >> users.txt
	fi
}

function list_users_and_types
{
	print_menu_header

	i=1
	while IFS='-' read user access pass default_pass; do
		printf "   | ${WHITE}%2d) %-15s  - %-12s         ${YELLOW}|\n" "$i" "$user" "$access"
		i=$((i+1))
	done < users.txt

	printf "   ===============================================\n\n"
	printf "${WHITE}   Press enter to continue...${WHITE}"
	read input
}

function delete_user
{
	print_menu_header
	printf "   |  ${WHITE}Select user to delete                      ${YELLOW}|\n"
	printf "   |                                             |\n"

	i=1
	while IFS='-' read user access pass; do
		printf "   | ${WHITE}%2d) %-15s  - %-12s         ${YELLOW}|\n" "$i" "$user" "$access"
		i=$((i+1))
	done < users.txt

	printf "   ===============================================\n\n"
	printf "${WHITE}   User to delete: ${WHITE}"
	read input

	if [[ ( "$input" != 1 && ! -z "$input" ) ]]; then
		i=1
		while read line; do
			if [ "$input" != "$i" ]; then
				echo "$line" >> tmp_users.txt
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

printf "${BACKGROUND}"

check_for_and_create_directories
init_admin

input=0
current_password=$(head -n 1 "users.txt")
name=""
password=""

while [[ ( "$input" != 6 && "$current_password" != "admin-power_user-buasa" ) ]]; do

	print_menu_header
	print_main_menu
	printf "${WHITE}   Option: ${WHITE}"
	read input

	if [ "$input" == 1 ]; then
		create_power_user
	elif [ "$input" == 2 ]; then
		create_general_user
	elif [ "$input" == 3 ]; then
		list_users_and_types
	elif [ "$input" == 4 ]; then
		delete_user
	elif [ "$input" == 5 ]; then
		./access.sh "admin" "power_user"
		printf "${BACKGROUND}"
	fi
done

printf "${DEFAULT}"
