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
echo "Creating environment for: $user_name"
echo "Directory name: $main_dir"
echo

# Check if directory exists and ask to overwrite
if [ -d "$main_dir" ]; then
    echo -n "Directory $main_dir already exists. Do you want to overwrite it? (y/n): "
    read overwrite
    if [ "$overwrite" != "y" ] && [ "$overwrite" != "Y" ]; then
        echo "Setup cancelled by user."
        exit 0
    fi
    rm -rf "$main_dir"
    echo "Removed existing directory"
fi

# Create directories
mkdir -p "$main_dir"

