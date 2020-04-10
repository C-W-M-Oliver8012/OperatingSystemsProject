#! /bin/bash

: '
This program controls the login system for the
bash user access system
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

function run_admin_script_if_user_text_does_not_exit
{
	if [ ! -f "users.txt" ]; then
		./admin.sh
		printf "${BACKGROUND}"
	fi
}

function print_menu_header
{
	clear
	printf "\n${YELLOW}   ===============================================\n"
	printf "   |  ${WHITE}Welcome to the Bash User Access System     ${YELLOW}|\n"
	printf "   ===============================================\n"
}

function print_menu
{
	printf "   |  ${GREEN}Login Screen: ${WHITE}To end program enter 1 for   ${YELLOW}|\n"
	printf "   |  ${WHITE}username and password.                     ${YELLOW}|\n"
	printf "   ===============================================\n\n"
}

function attempt_login
{
	while IFS='-' read user access pass default_pass; do
		if [[ ( "$1" == "$user" && "$2" == "$pass" ) ]]; then
			priv="$access"
			login=1
			break
		fi
	done < users.txt
}

function login_user_if_possible
{
	if [ "$login" -eq 1 ]; then
		admin_str=$(head -n 1 users.txt)
		IFS='-' read admin_user admin_access admin_pass default_admin_pass <<< "$admin_str"
		if [[ ( "$username" == "$admin_user" && "$password" == "$admin_pass" ) ]]; then
			./admin.sh
			printf "${BACKGROUND}"
		else
			./user.sh "$username" "$priv"
			printf "${BACKGROUND}"
		fi
	fi
}

function check_if_user_wants_to_exit_program
{
	if [[ ( "$username" -eq 1 && "$password" -eq 1 ) ]]; then
		login=2
	fi
}

function prompt_and_get_username_and_password
{
	printf "${WHITE}   Username: ${WHITE}"
	read username
	printf "${WHITE}   Password: ${WHITE}"
	read -s password
}


: '
The following code is what is actually running
for the program.
'

printf "${BACKGROUND}"

run_admin_script_if_user_text_does_not_exit

username=""
password=""
priv=""
login=0

while [ "$login" -ne 2 ]; do
	login=0

	print_menu_header
	print_menu
	prompt_and_get_username_and_password
	check_if_user_wants_to_exit_program
	attempt_login $username $password $login
	login_user_if_possible
done

printf "${DEFAULT}"
clear
