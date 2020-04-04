#! /bin/bash

if [ -f "users.txt" ]; then
	rm users.txt
fi

if [ -d "Financial_Files" ]; then
	rm -r Financial_Files
fi

if [ -d "General_Files" ]; then
	rm -r General_Files
fi

if [ -d "Project_Files" ]; then
	rm -r Project_Files
fi
