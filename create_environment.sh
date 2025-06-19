#!/bin/bash
# Script to create submission reminder app environmenet
# Get user name
echo -n "Enter your name: "
read user_name

# Check if name is empty
if [ -z "$user_name" ]; then
    echo "Error: Name cannot be empty!"
    exit 1
fi

# Make directory name from user name
clean_name=$(echo "$user_name" | tr -d ' ' | tr '[:upper:]' '[:lower:]')
main_dir="submission_reminder_${clean_name}"
