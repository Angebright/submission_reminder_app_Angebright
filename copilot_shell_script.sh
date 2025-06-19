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

# Define paths
config_file="$app_directory/config/config.env"
startup_script="$app_directory/startup.sh"

# Check if config file exists
if [ ! -f "$config_file" ]; then
    echo "Error: Configuration file not found at $config_file"
    echo "Please ensure the application environment is properly set up."
    exit 1
fi

# Display current assignment
echo "Current configuration:"
current_assignment=$(grep "^ASSIGNMENT=" "$config_file" | head -1)
echo "$current_assignment"

# Get new assignment name
echo
echo "Enter the new assignment name:"
echo -n "Assignment name: "
read new_assignment_name

# Check if name is empty
if [ -z "$new_assignment_name" ]; then
    echo "Error: Assignment name cannot be empty!"
    exit 1
fi

# Check for special characters
if [[ "$new_assignment_name" =~ [\"\'\\] ]]; then
    echo "Warning: Assignment name contains special characters that might cause issues."
    echo -n "Continue anyway? (y/n): "
    read continue_choice
    if [ "$continue_choice" != "y" ] && [ "$continue_choice" != "Y" ]; then
        echo "Operation cancelled due to invalid input."
        exit 1
    fi
fi

# Confirm the change
echo
echo "You are about to change the assignment to: \"$new_assignment_name\""
echo -n "Continue? (y/n): "
read confirm_change

if [ "$confirm_change" != "y" ] && [ "$confirm_change" != "Y" ]; then
    echo "Operation cancelled by user."
    exit 0
fi

# Update assignment in config file
echo "Updating assignment in configuration file..."

# Create backup
backup_file="${config_file}.backup.$(date +%Y%m%d_%H%M%S)"
cp "$config_file" "$backup_file"
echo "✓ Created backup: $backup_file"

# Update the assignment value
cat > "$config_file" << EOF
# This is the config file
ASSIGNMENT="$new_assignment_name"
DAYS_REMAINING=2
EOF
# sed -i "2s/^ASSIGNMENT=.*/ASSIGNMENT=\"$new_assignment_name\"/" "$config_file"
echo "✓ Updated ASSIGNMENT in config file"

