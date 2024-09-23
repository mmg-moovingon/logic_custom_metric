#!/bin/bash

# Define variables
FILE="/var/www/html/load3.srv-analytics.info/crons/input/rtb_scala/rsync_monitor.txt"
OUTPUT_DIR="/var/lib/node_exporter/textfile_collector"
OUTPUT_FILE="$OUTPUT_DIR/rsync_monitor_file_age_in_minutes.prom"
METRIC_NAME="rsync_monitor_file_age_minutes"

# Ensure the output directory exists
mkdir -p $OUTPUT_DIR

# Check if the file exists
if [[ -f "$FILE" ]]; then
    # Get the current date and the file's modification date in seconds since epoch
    current_date=$(date +%s)
    file_modification_date=$(stat -c %Y "$FILE")

    # Calculate the file age in minutes
    file_age_minutes=$(( (current_date - file_modification_date) / 60 ))

    # Write the metric in Prometheus exposition format
    echo "# HELP $METRIC_NAME Age of the rsync_monitor.txt file in minutes" > $OUTPUT_FILE
    echo "# TYPE $METRIC_NAME gauge" >> $OUTPUT_FILE
    echo "$METRIC_NAME $file_age_minutes" >> $OUTPUT_FILE
else
    echo "# HELP $METRIC_NAME Age of the rsync_monitor.txt file in minutes" > $OUTPUT_FILE
    echo "# TYPE $METRIC_NAME gauge" >> $OUTPUT_FILE
    echo "$METRIC_NAME 0" >> $OUTPUT_FILE  # If the file doesn't exist, output 0 or an appropriate value
fi
