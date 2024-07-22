#!/bin/bash

# Default settings file
SETTINGS_FILE="settings"
JOBS_DIR="jobs"
STATUS_FILE="job_status.log"

# Check if the settings file exists
if [[ ! -f "$SETTINGS_FILE" ]]; then
    echo "Settings file $SETTINGS_FILE not found."
    exit 1
fi

# Load settings
source "$SETTINGS_FILE"

# List available jobs and their descriptions
function list_jobs {
    echo "Available jobs:"
    for config_file in $JOBS_DIR/*.config; do
        JOB_NAME=$(basename "$config_file" .config)
        DESCRIPTION=$(grep "^DESCRIPTION=" "$config_file" | sed 's/DESCRIPTION=//')
        echo "$JOB_NAME: $DESCRIPTION"
    done
}

# Run a job
function run_job {
    JOB_NAME="$1"
    CONFIG_FILE="$JOBS_DIR/$JOB_NAME.config"
    SCRIPT_FILE="$JOBS_DIR/$JOB_NAME.script"

    # Validate job files existence
    if [[ ! -f "$CONFIG_FILE" || ! -f "$SCRIPT_FILE" ]]; then
        echo "Job configuration or script file not found for $JOB_NAME."
        exit 1
    fi

    # Load job configuration
    source "$CONFIG_FILE"

    # Create a timestamp for the job
    TIMESTAMP=$(date +"%Y%m%d%H%M%S")
    JOB_LOG="job_${JOB_NAME}_${TIMESTAMP}.log"

    # SSH into the HPC system and execute the job script
    echo "Connecting to HPC system..."
    ssh $USER_NAME@$HPC_ADDRESS << EOF
        # Log the start of the job
        echo "Job $JOB_NAME started at \$(date)" >> $STATUS_FILE

        # Execute the job script
        echo "Executing job script..."
        bash $SCRIPT_FILE

        # Log the end of the job
        echo "Job $JOB_NAME completed at \$(date)" >> $STATUS_FILE

        # End the interactive session
        echo "Ending interactive session..."
        exit
EOF

    echo "Job $JOB_NAME is running. Logs are available in $JOB_LOG."
}

# Show status of running jobs
function show_status {
    if [[ -f "$STATUS_FILE" ]]; then
        cat "$STATUS_FILE"
    else
        echo "No job status file found."
    fi
}

# Main script logic
case "$1" in
    list)
        list_jobs
        ;;
    run)
        if [[ -z "$2" ]]; then
            echo "Usage: $0 run <job_name>"
            exit 1
        fi
        run_job "$2"
        ;;
    status)
        show_status
        ;;
    *)
        echo "Usage: $0 {list|run <job_name>|status}"
        exit 1
        ;;
esac
