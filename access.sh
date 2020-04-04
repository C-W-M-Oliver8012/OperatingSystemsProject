#! /bin/bash

function print_menu_header 
{
	clear

	echo " "
	echo "   ==============================================="
	echo "   | Welcome to the Bash User Access System      |"
	echo "   ==============================================="
}

if [[ ( -d "Financial_Files" && -d "General_Files" && -d "Project_Files" ) ]]; then
	print_menu_header
	echo "   | 1) General Files                            |"
	echo "   | 2) Project Files                            |"
	
	if [ "$1" == "power_user" ]; then
		echo "   | 3) Financial Files                          |"
	fi
	
	echo "   ==============================================="
	echo " "
	
	read -p "   Directory to Open: " input
	
	if [ "$input" == 1 ]; then
		clear
		echo " "
		echo "   General Files"
		echo "   ======================"
		for entry in "General_Files"/*; do
			echo "   $entry"
		done
	elif [ "$input" == 2 ]; then
		clear
		echo " "
		echo "   Project Files"
		echo "   ======================"
		for entry in "Project_Files"/*; do
			echo "   $entry"
		done
	elif [[ ( "$input" == 3 && "$1" == "power_user" ) ]]; then
		clear
		echo " "
		echo "   Financial Files"
		echo "   ======================"
		for entry in "Financial_Files"/*; do
			echo "   $entry"
		done
	fi
	
	echo " "
	
	read -p "   Press enter to return to menu..." input
fi


