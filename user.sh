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
	printf "\n%b   ===============================================\n" "$YELLOW"
	printf "   |  %b%-20s : %-20s%b|\n" "$GREEN" "$1" "$2" "$YELLOW"
	printf "   ===============================================\n"
	printf "   |  %bYou have logged in with the default        %b|\n" "$WHITE" "$YELLOW"
	printf "   |  %bpassword. Enter 1 to change the password   %b|\n" "$WHITE" "$YELLOW"
	printf "   |  %band 2 in order to logout.                  %b|\n" "$WHITE" "$YELLOW"
	printf "   ===============================================\n\n"
	printf "%b   Option: " "$WHITE"
}

function enter_new_password_prompt
{
	clear
	printf "\n%b   ===============================================\n" "$YELLOW"
	printf "   |  %b%-20s : %-20s%b|\n" "$GREEN" "$1" "$2" "$YELLOW"
	printf "   ===============================================\n"
	printf "   |  %bPlease enter a new password!               %b|\n" "$WHITE" "$YELLOW"
	printf "   ===============================================\n\n"
	printf "%b   New Password: " "$WHITE"
}


function check_change_password
{
	# find current user and check if they have changed their default password
	pass_data=""
	matched=0
	# reads users.txt line by line and checks user credentials
	while IFS='-' read -r user access pass default_pass; do
		# if the user is the current user and the default password has not
		# changed
		if [ "$1" = "$user" ] && [ "$pass" = "$default_pass" ]; then
			# user with unchanged password found
			matched=1
			break
		fi
	done < users.txt

	# give the option to change password or logout
	if [ "$matched" = 1 ]; then
		pass_changed=0
		while [ "$pass_changed" = 0 ]; do
			print_default_password_prompt "$1" "$2"
			read -r input
			# if user wants to change password
			if [ "$input" = 1 ]; then
				enter_new_password_prompt "$1" "$2"
				read -r -s new_password
				if [ "$new_password" != "$default_pass" ] && [ -n "$new_password" ]; then
					pass_data="$user-$access-$new_password-$default_pass"
					pass_changed=1
				fi
			# if user wants to logout instead of changing password
			elif [ "$input" = 2 ]; then
				pass_data="no_change"
				pass_changed=2
			fi
		done
	fi

	# change the password in the file or logout
	if [ "$pass_data" != "no_change" ] && [ "$matched" = 1 ]; then
		# adds every user into a temp file except for the user being changed
		while IFS='-' read -r user access pass default_pass; do
			if [ "$user" != "$1" ]; then
				echo "$user-$access-$pass-$default_pass" >> tmp_users.txt
			fi
		done < users.txt

		# deletes users.txt file to
		rm users.txt
		# adds all users from temp file back into the users.txt file
		while read -r line; do
			echo "$line" >> users.txt
		done < tmp_users.txt
		# adds the current users updated credentials back to the file
		echo "$pass_data" >> users.txt
		# deletes temp file
		rm tmp_users.txt
		input=""
	# logs user out
	elif [ "$matched" = 1 ]; then
		option=3
	fi
}

function change_password
{
	# find current user
	pass_data=""
	matched=0
	# reads users.txt line by line and checks user credentials
	while IFS='-' read -r user access pass default_pass; do
		# if the user is the current user
		if [ "$1" = "$user" ]; then
			# current user found
			matched=1
			break
		fi
	done < users.txt

	# prompt to change password and get new password
	if [ "$matched" = 1 ]; then
		pass_changed=0
		while [ "$pass_changed" = 0 ]; do
			enter_new_password_prompt "$1" "$2"
			read -r -s new_password
			# if the new password is not the current pass / the default pass / null
			if [ "$new_password" != "$pass" ] && [ "$new_password" != "$default_pass" ] && [ -n "$new_password" ]; then
				pass_data="$user-$access-$new_password-$default_pass"
				# breaks from loop
				pass_changed=1
			fi
		done
	fi

	# change the password in the file
	if [ "$matched" = 1 ]; then
		while IFS='-' read -r user access pass default_pass; do
			if [ "$user" != "$1" ]; then
				echo "$user-$access-$pass-$default_pass" >> tmp_users.txt
			fi
		done < users.txt

		# deletes users.txt file
		rm users.txt
		# adds all users from temp file back into the users.txt file
		while read -r line; do
			echo "$line" >> users.txt
		done < tmp_users.txt
		# adds the current users updated credentials back to the file
		echo "$pass_data" >> users.txt
		# deletes temp file 
		rm tmp_users.txt
	fi
}

function print_menu
{
	clear
	printf "\n%b   ===============================================\n" "$YELLOW"
	printf "   |  %b%-20s : %-20s%b|\n" "$GREEN" "$1" "$2" "$YELLOW"
	printf "   ===============================================\n"
	printf "   |  %b1) Open a directory                        %b|\n" "$WHITE" "$YELLOW"
	printf "   |  %b2) Change password                         %b|\n" "$WHITE" "$YELLOW"
	printf "   |  %b3) Logout                                  %b|\n" "$WHITE" "$YELLOW"
	printf "   ===============================================\n\n"
}


: '
The following code is what is actually running
for the program.
'

printf "%b" "$BACKGROUND"

input=""
option=0
check_change_password "$1" "$2"

while [ "$option" != 3 ]; do

	print_menu "$1" "$2"
	printf "%b   Option: " "$WHITE"
	read -r option

	if [ "$option" = 1 ]; then
		./access.sh "$1" "$2"
		printf "%b" "$BACKGROUND"
	elif [ "$option" = 2 ]; then
		change_password "$1" "$2"
	fi
done

printf "%b" "$DEFAULT"
