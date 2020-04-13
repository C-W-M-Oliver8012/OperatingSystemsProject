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
	# checks if the users.txt file exist and runs the admin script if
	# does not which creates the users.txt script
	if [ ! -f "users.txt" ]; then
		./admin.sh
		printf "%b" "$BACKGROUND"
	fi
}

function print_menu_header
{
	clear
	printf "\n%b   ===============================================\n" "$YELLOW"
	printf "   |  %bWelcome to the Bash User Access System     %b|\n" "$WHITE" "$YELLOW"
	printf "   ===============================================\n"
}

function print_menu
{
	printf "   |  %bLogin Screen: %bTo end program enter 1 for   %b|\n" "$GREEN" "$WHITE" "$YELLOW"
	printf "   |  %busername and password.                     %b|\n" "$WHITE" "$YELLOW"
	printf "   ===============================================\n\n"
}

function attempt_login
{
	# reads line by line from the users.txt file and splits the line
	# using the '-' character
	while IFS='-' read -r user access pass default_pass; do
		# checks if user exist
		if [ "$1" = "$user" ] && [ "$2" = "$pass" ]; then
			# sets privledge
			priv="$access"
			# sets login to true
			login=1
			break
		fi
	done < users.txt
}

function login_user_if_possible
{
	# if login is true
	if [ "$login" = 1 ]; then
		# gets admin information
		admin_str=$(head -n 1 users.txt)
		IFS='-' read -r admin_user admin_access admin_pass default_admin_pass <<< "$admin_str"
		# if the logged in user is admin, run the admin script
		if [ "$username" = "$admin_user" ] && [ "$password" = "$admin_pass" ]; then
			./admin.sh
			printf "%b" "$BACKGROUND"
		# if the logged in user is not the admin, run the user script
		else
			./user.sh "$username" "$priv"
			printf "%b" "$BACKGROUND"
		fi
	fi
}

function check_if_user_wants_to_exit_program
{
	# exits program if user enters 1 for both username and password
	if [ "$username" = 1 ] && [ "$password" = 1 ]; then
		# sets login to exit program
		login=2
	fi
}

function prompt_and_get_username_and_password
{
	# gets username and password from the user to attempt to login
	printf "%b   Username: " "$WHITE"
	read -r username
	printf "%b   Password: " "$WHITE"
	read -r -s password
}


: '
The following code is what is actually running
for the program.
'

printf "%b" "$BACKGROUND"

# checks if users.txt file exist and creates it if it does not
run_admin_script_if_user_text_does_not_exit

username=""
password=""
priv=""
login=0

# while user does not want to exit program
while [ "$login" != 2 ]; do
	# login is false
	login=0

	print_menu_header
	print_menu
	prompt_and_get_username_and_password
	check_if_user_wants_to_exit_program
	attempt_login "$username" "$password" "$login"
	login_user_if_possible
done

printf "%b" "$DEFAULT"
clear
