#!/bin/bash

# This script allows users to change the assignment name in config.env and check submission status

echo "This script updates the assignment name and checks submission status"
echo

# Find submission reminder directory
echo "Searching for submission reminder directory..."
dirs=(submission_reminder_*)
if [ ${#dirs[@]} -eq 0 ] || [ ! -d "${dirs[0]}" ]; then
    echo "Error: No submission_reminder_* directory found!"
    echo "Please run create_environment.sh first to create the application environment."
    exit 1
elif [ ${#dirs[@]} -gt 1 ]; then
    echo "Multiple submission directories found:"
    for i in "${!dirs[@]}"; do
        echo "$((i+1)). ${dirs[i]}"
    done
    echo -n "Select directory number: "
    read selection
    if [[ "$selection" =~ ^[0-9]+$ ]] && [ "$selection" -ge 1 ] && [ "$selection" -le "${#dirs[@]}" ]; then
        app_directory="${dirs[$((selection-1))]}"
    else
        echo "Invalid selection!"
        exit 1
    fi
else
    app_directory="${dirs[0]}"
fi

echo "✓ Found directory: $app_directory"

