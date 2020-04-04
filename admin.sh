#! /bin/bash

if [ ! -d "General_Files" ]; then
	mkdir General_Files
fi

if [ ! -d "Project_Files" ]; then
	mkdir Project_Files
fi

if [ ! -d "Financial_Files" ]; then
	mkdir Financial_Files
fi

if [ ! -f "users.txt" ]; then
	> users.txt
	echo "admin-power_user-buasa" > users.txt
fi

function print_menu_header 
{
	clear

	echo " "
	echo "   ==============================================="
	echo "   | Welcome to the Bash User Access System      |"
	echo "   ==============================================="
}

input=0
current_password=$(head -n 1 "users.txt")

if [ "$current_password" == "admin-power_user-buasa" ]; then

	while [[ ( $input != 1 && $input != 2 ) ]]; do

		print_menu_header
		echo "   | You are logged in as admin. The default     |"
		echo "   | password is 'buasa'. Press 1 to change the  |"
		echo "   | password and 2 to quit the program.         |"
		echo "   ==============================================="
		echo " "

		read -p "   Option: " input
	done

	password="buasa"

	if [ $input == 1 ]; then

		print_menu_header
		echo "   | Please enter a new password!                |"
		echo "   ==============================================="
		echo " "
		read -s -p "   New Password: " password
		echo "admin-power_user-$password" > users.txt
	fi
fi

input=0
current_password=$(head -n 1 "users.txt")
name=""
password=""

while [[ ( $input != 5 && "$current_password" != "admin-power_user-buasa" ) ]]; do

	print_menu_header
	echo "   | You are admin: choose an option             |"
	echo "   |                                             |"
	echo "   | 1) Create a new Power User                  |"
	echo "   | 2) Create a new General User                |"
	echo "   | 3) List Users                               |"
	echo "   | 4) Delete Users                             |"
	echo "   | 5) Log Out                                  |"
	echo "   ==============================================="
	echo " "
	read -p "   Option: " input

	if [ "$input" == 1 ]; then
		
		print_menu_header
		echo "   | Enter name for new Power User               |"
		echo "   ==============================================="
		echo " "
		read -p "   Power User's Name: " name


		print_menu_header
		echo "   | Enter default password for new Power User   |"
		echo "   ==============================================="
		echo " "
		read -s -p "   Power User's default password: " password
		echo "$name-power_user-$password" >> users.txt
	fi

	if [ "$input" == 2 ]; then
		
		print_menu_header
		echo "   | Enter name for new General User             |"
		echo "   ==============================================="
		echo " "
		read -p "   General User's Name: " name


		print_menu_header
		echo "   | Enter default password for new General User |"
		echo "   ==============================================="
		echo " "
		read -s -p "   General User's default password: " password
		echo "$name-general_user-$password" >> users.txt
	fi
	
	if [ "$input" == 3 ]; then
		
		print_menu_header
		
		i=1
		while IFS='-' read user access pass; do
			printf "   | %2d) %-15s  - %-12s         |\n" $i $user $access
			i=$((i+1))
		done < users.txt
		
		echo "   ==============================================="
		echo " "
		read -p "   Press enter to continue..." input
	fi
	
	if [ "$input" == 4 ]; then
	
		print_menu_header
		echo "   | Select user to delete                       |"
		echo "   |                                             |"
		
		i=1
		while IFS='-' read user access pass; do
			printf "   | %2d) %-15s  - %-12s         |\n" $i $user $access
			i=$((i+1))
		done < users.txt
		
		echo "   ==============================================="
		echo " "
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
	fi
done

