#! /bin/bash

: '
This program controls the user menu once a user has logged in
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



function print_default_password_prompt
{
	clear
	printf "\n${YELLOW}   ===============================================\n"
	printf "   |  ${GREEN}%-20s : %-20s${YELLOW}|\n" "$1" "$2"
	printf "   ===============================================\n"
	printf "   |  ${WHITE}You have logged in with the default        ${YELLOW}|\n"
	printf "   |  ${WHITE}password. Enter 1 to change the password   ${YELLOW}|\n"
	printf "   |  ${WHITE}and 2 in order to logout.                  ${YELLOW}|\n"
	printf "   ===============================================\n\n"
	printf "${WHITE}   Option: "
}

function enter_new_password_prompt
{
	clear
	printf "\n${YELLOW}   ===============================================\n"
	printf "   |  ${GREEN}%-20s : %-20s${YELLOW}|\n" "$1" "$2"
	printf "   ===============================================\n"
	printf "   |  ${WHITE}Please enter a new password!               ${YELLOW}|\n"
	printf "   ===============================================\n\n"
	printf "${WHITE}   New Password: "
}

# this function is an obsolute mess BUT IT WORKS
# DON'T TOUCH IT FOR NOW... I WILL CLEAN IT UP!!
function check_change_password
{
	# find current user and check if they have changed their default password
	pass_data=""
	matched=0
	while IFS='-' read user access pass default_pass; do
		if [[ ( "$1" == "$user" && "$pass" == "$default_pass" ) ]]; then
			matched=1
			break
		fi
	done < users.txt

	# give the option to change password or logout
	if [ "$matched" == 1 ]; then
		pass_changed=0
		while [ "$pass_changed" == 0 ]; do
			print_default_password_prompt "$1" "$2"
			read input
			if [ "$input" == 1 ]; then
				enter_new_password_prompt "$1" "$2"
				read -s new_password
				if [[ ( "$new_password" != "$default_pass" && ! -z "$new_password" ) ]]; then
					pass_data="$user-$access-$new_password-$default_pass"
					pass_changed=1
				fi
			elif [ "$input" == 2 ]; then
				pass_data="no_change"
				pass_changed=2
			fi
		done
	fi

	# change the password in the file or logout
	if [[ ( "$pass_data" != "no_change" && "$matched" == 1 ) ]]; then
		while IFS='-' read user access pass default_pass; do
			if [ "$user" != "$1" ]; then
				echo "$user-$access-$pass-$default_pass" >> tmp_users.txt
			fi
		done < users.txt

		rm users.txt
		while read line; do
			echo $line >> users.txt
		done < tmp_users.txt
		echo "$pass_data" >> users.txt
		rm tmp_users.txt
		input=""
	elif [ "$matched" == 1 ]; then
		option=3
	fi
}

function change_password
{
	# find current user
	pass_data=""
	matched=0
	while IFS='-' read user access pass default_pass; do
		if [ "$1" == "$user" ]; then
			matched=1
			break
		fi
	done < users.txt

	# prompt to change password and get new password
	if [ "$matched" == 1 ]; then
		pass_changed=0
		while [ "$pass_changed" == 0 ]; do
			enter_new_password_prompt "$1" "$2"
			read -s new_password
			if [[ ( "$new_password" != "$pass" && "$new_password" != "$default_pass" && ! -z "$new_password" ) ]]; then
				pass_data="$user-$access-$new_password-$default_pass"
				pass_changed=1
			fi
		done
	fi

	# change the password in the file
	if [ "$matched" == 1 ]; then
		while IFS='-' read user access pass default_pass; do
			if [ "$user" != "$1" ]; then
				echo "$user-$access-$pass-$default_pass" >> tmp_users.txt
			fi
		done < users.txt

		rm users.txt
		while read line; do
			echo $line >> users.txt
		done < tmp_users.txt
		echo "$pass_data" >> users.txt
		rm tmp_users.txt
	fi
}

function print_menu
{
	clear
	printf "\n${YELLOW}   ===============================================\n"
	printf "   |  ${GREEN}%-20s : %-20s${YELLOW}|\n" "$1" "$2"
	printf "   ===============================================\n"
	printf "   |  ${WHITE}1) Open a directory                        ${YELLOW}|\n"
	printf "   |  ${WHITE}2) Change password                         ${YELLOW}|\n"
	printf "   |  ${WHITE}3) Logout                                  ${YELLOW}|\n"
	printf "   ===============================================\n\n"
}


: '
The following code is what is actually running
for the program.
'

printf "${BACKGROUND}"

input=""
option=0
check_change_password "$1" "$2"

while [ "$option" != 3 ]; do

	print_menu "$1" "$2"
	printf "${WHITE}   Option: ${WHITE}"
	read option

	if [ "$option" == 1 ]; then
		./access.sh "$1" "$2"
		printf "${BACKGROUND}"
	elif [ "$option" == 2 ]; then
		change_password "$1" "$2"
	fi
done

printf "${DEFAULT}"
