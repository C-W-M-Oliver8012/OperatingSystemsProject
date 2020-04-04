#! /bin/bash

if [ ! -f "users.txt" ]; then
	./admin.sh
fi

function print_menu_header 
{
	clear

	echo " "
	echo "   ==============================================="
	echo "   | Welcome to the Bash User Access System      |"
	echo "   ==============================================="
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

username=""
password=""
priv=""
login=0

while [ $login != 2 ]; do
	login=0

	print_menu_header
	echo "   | Please attempt to log in. Type 1 for user   |"
	echo "   | and password to end program.                |"
	echo "   ==============================================="
	echo " "

	read -p "   Username: " username
	read -s -p "   Password: " password

	if [[ ( $username == 1 && $password == 1 ) ]]; then
		login=2
		break
	fi

	attempt_login $username $password $login
	
	if [ $login == 1 ]; then
		admin_str=$(head -n 1 users.txt)
		IFS='-' read admin_user admin_access admin_pass <<< "$admin_str"
		if [[ ( "$username" = "$admin_user" && "$password" = "$admin_pass" ) ]]; then
			./admin.sh
		else
			./user.sh
		fi
	fi
done

echo " "
