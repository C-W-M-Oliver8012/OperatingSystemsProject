#! /bin/bash

function print_menu_header 
{
	clear

	echo " "
	echo "   ==============================================="
	echo "   | Welcome to the Bash User Access System      |"
	echo "   ==============================================="
}

print_menu_header
echo "   | You have successfully logged in!            |"
echo "   | Unfortunately there are no supported        |"
echo "   | options at the moment. Press enter to       |"
echo "   | return to loggin screen.                    |"
echo "   ==============================================="
echo " "
read -p "   Press enter..."
