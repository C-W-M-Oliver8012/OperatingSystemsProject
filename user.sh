#! /bin/bash

: '
This program controls the user menu once a user has logged in
'


: '
The following code are functions that will be used
in the main code below all of the functions.
'

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
	echo "   | You have successfully logged in!            |"
	echo "   | Unfortunately there are no supported        |"
	echo "   | options at the moment. Press enter to       |"
	echo "   | return to loggin screen.                    |"
	echo "   ==============================================="
	echo " "
}


: '
The following code is what is actually running
for the program.
'

print_menu_header
print_menu
read -p "   Press enter..."
