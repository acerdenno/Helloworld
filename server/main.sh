#!/bin/bash

# Load environment variables from .env file
export $(grep -v '^#' .env | xargs)

# Step 1: Git pull
echo "===> [1/3] Pull changes from repo"
git pull

# Step 2: Give execution permission to all .sh files in the directory
echo "===> [2/3] Set execution permissions"
chmod +x *.sh

if [ -z "$SCRIPT" ]; then
  echo "SCRIPT environment variable is not set. Exiting."
  exit 1
fi

if [ ! -f "$SCRIPT" ]; then
  echo "Script file $SCRIPT does not exist. Exiting."
  exit 1
fi

OUTPUT_FILE="${SCRIPT}.out"

# Step 3: Use salloc to request resources and execute the R script
echo "===> [3/3] Request resources and run the R script"
salloc -p standard --cpus-per-task="$CPUS" --time="$TIME" --mem="$MEM" -- bash -c "
  # Load the R module
  module load $R_MODULE

  # Run the R script using R CMD BATCH
  R CMD BATCH --no-save $SCRIPT $OUTPUT_FILE
"
echo "Output file path: $(realpath $OUTPUT_FILE)"
echo "Output file size: $(du -h $OUTPUT_FILE | awk '{print $1}')"



