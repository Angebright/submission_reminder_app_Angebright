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
echo "Creating and populating files..."

# Create directories
mkdir -p "$main_dir"
echo "✓ Created directory: $main_dir"

echo "Creating subdirectories..."
mkdir -p "$main_dir/app"
echo "✓ Created directory: $main_dir/app"
mkdir -p "$main_dir/modules"
echo "✓ Created directory: $main_dir/modules"
mkdir -p "$main_dir/assets"
echo "✓ Created directory: $main_dir/assets"
mkdir -p "$main_dir/config"
echo "✓ Created directory: $main_dir/config"

echo "Creating and populating files..."

# Create config file
cat > "$main_dir/config/config.env" << 'EOF'
# This is the config file
ASSIGNMENT="Shell Navigation"
DAYS_REMAINING=2
EOF
echo "✓ Created file: $main_dir/config/config.env"

# Create reminder.sh
cat > "$main_dir/app/reminder.sh" << 'EOF'
#!/bin/bash

# Source environment variables and helper functions
source ./config/config.env
source ./modules/functions.sh

# Path to the submissions file
submissions_file="./assets/submissions.txt"
# Print remaining time and run the reminder function
echo "Assignment: $ASSIGNMENT"
echo "Days remaining to submit: $DAYS_REMAINING days"
echo "--------------------------------------------"

check_submissions $submissions_file
EOF
echo "✓ Created file: $main_dir/app/reminder.sh"
# Create functions.sh
cat > "$main_dir/modules/functions.sh" << 'EOF'
#!/bin/bash

# Function to read submissions file and output students who have not submitted
function check_submissions {
    local submissions_file=$1
    echo "Checking submissions in $submissions_file"

    # Skip the header and iterate through the lines
    while IFS=, read -r student assignment status; do
        # Remove leading and trailing whitespace
        student=$(echo "$student" | xargs)
        assignment=$(echo "$assignment" | xargs)
        status=$(echo "$status" | xargs)

        # Check if assignment matches and status is not submitted
        if [[ "$assignment" == "$ASSIGNMENT" && "$status" == "not submitted" ]]; then
            echo "Reminder: $student has not submitted the $ASSIGNMENT assignment!"
        fi
    done < <(tail -n +2 "$submissions_file") # Skip the header
}
EOF
echo "✓ Created file: $main_dir/modules/functions.sh"

# Create submissions.txt
cat > "$main_dir/assets/submissions.txt" << 'EOF'

student, assignment, submission status
Chinemerem, Shell Navigation, not submitted
Chiagoziem, Git, submitted
Divine, Shell Navigation, not submitted
Anissa, Shell Basics, submitted
Victor, Shell Navigation, not submitted
Derrick, Linux and IT Tools, submitted
Yannick, Self Leadership and Team Dynamics, not submitted
George, E-Lab, submitted
Deborah, Reflective Thinking, not submitted
EOF
echo "✓ Created file: $main_dir/assets/submissions.txt"

# Create startup.sh
cat > "$main_dir/startup.sh" << 'EOF'
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
EOF
echo "✓ Created file: $main_dir/startup.sh"

