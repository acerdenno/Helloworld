#!/bin/bash

# Load environment variables from .env file
export $(grep -v '^#' .env | xargs)

# Step 1: Git pull
echo "Pulling latest changes from git..."
git pull

# Step 2: Give execution permission to all .sh files in the directory
echo "Setting execution permissions for all .sh files..."
chmod +x *.sh

# Step 3: Run the script specified in the SCRIPT environment variable
echo "Running the script specified in SCRIPT environment variable..."
if [ -z "$SCRIPT" ]; then
  echo "SCRIPT environment variable is not set. Exiting."
  exit 1
fi

if [ -f "$SCRIPT" ]; then
  python "$SCRIPT"
else
  echo "Script file $SCRIPT does not exist. Exiting."
  exit 1
fi
