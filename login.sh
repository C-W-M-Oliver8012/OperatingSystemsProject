#! /bin/bash

: '
This program controls the login system for the 
bash user access system
'


: '
The following code are functions that will be used
in the main code below all of the functions.
'

function run_admin_script_if_user_text_does_not_exit
{
	if [ ! -f "users.txt" ]; then
		./admin.sh
	fi
}

function print_menu_header 
{
	clear

	echo " "
	echo "   ==============================================="
	echo "   | Welcome to the Bash User Access System      |"
	echo "   ==============================================="
}

function print_menu
{
	echo "   | Please attempt to log in. Type 1 for user   |"
	echo "   | and password to end program.                |"
	echo "   ==============================================="
	echo " "
}

function attempt_login 
{
	while IFS='-' read user access pass; do
		if [[ ( "$1" == "$user" && "$2" == "$pass" ) ]]; then
			priv=$access
			login=1
			break
		fi
	done < users.txt
}

function login_user_if_possible
{
	if [ $login == 1 ]; then
		admin_str=$(head -n 1 users.txt)
		IFS='-' read admin_user admin_access admin_pass <<< "$admin_str"
		if [[ ( "$username" = "$admin_user" && "$password" = "$admin_pass" ) ]]; then
			./admin.sh
		else
			./user.sh
		fi
	fi
}

function check_if_user_wants_to_exit_program
{
	if [[ ( $username == 1 && $password == 1 ) ]]; then
		login=2
	fi
}

function prompt_and_get_username_and_password
{
	read -p "   Username: " username
	read -s -p "   Password: " password
}


: '
The following code is what is actually running
for the program.
'

run_admin_script_if_user_text_does_not_exit

username=""
password=""
priv=""
login=0

while [ $login != 2 ]; do
	login=0

	print_menu_header
	print_menu
	prompt_and_get_username_and_password
	check_if_user_wants_to_exit_program
	attempt_login $username $password $login
	login_user_if_possible
done

echo " "
