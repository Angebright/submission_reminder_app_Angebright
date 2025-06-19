#!/bin/bash
# Startup script for submission reminder app

# Source configuration and functions
source config/config.env
source modules/functions.sh

echo "=== Submission Reminder App ==="
echo "Assignment: $ASSIGNMENT"
echo "Deadline: $DEADLINE"
echo

# Check current directory structure
if [ ! -f "assets/submissions.txt" ]; then
    echo "Error: submissions.txt not found!"
    exit 1
fi

if [ ! -f "app/reminder.sh" ]; then
    echo "Error: reminder.sh not found!"
    exit 1
fi

echo "Starting reminder application..."
echo

# Execute the main reminder script
./app/reminder.sh

echo
echo "Application execution completed."
