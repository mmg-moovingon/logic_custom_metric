#!/bin/bash

# Define variables
FILE="/usr/local/share/udger/udgerdb_v3.dat"
OUTPUT_DIR="/var/lib/node_exporter/textfile_collector"
OUTPUT_FILE="$OUTPUT_DIR/udgerdb_file_age_in_days.prom"
METRIC_NAME="udgerdb_file_age_days"

# Ensure the output directory exists
mkdir -p $OUTPUT_DIR

# Check if the file exists
if [[ -f "$FILE" ]]; then
    # Get the current date and the file's modification date in seconds since epoch
    current_date=$(date +%s)
    file_modification_date=$(stat -c %Y "$FILE")

    # Calculate the file age in days
    file_age_days=$(( (current_date - file_modification_date) / 86400 ))

    # Write the metric in Prometheus exposition format
    echo "# HELP $METRIC_NAME Age of the udgerdb_v3.dat file in days" > $OUTPUT_FILE
    echo "# TYPE $METRIC_NAME gauge" >> $OUTPUT_FILE
    echo "$METRIC_NAME $file_age_days" >> $OUTPUT_FILE
else
    echo "# HELP $METRIC_NAME Age of the udgerdb_v3.dat file in days" > $OUTPUT_FILE
    echo "# TYPE $METRIC_NAME gauge" >> $OUTPUT_FILE
    echo "$METRIC_NAME 0" >> $OUTPUT_FILE  # If the file doesn't exist, output 0 or an appropriate value
fi
