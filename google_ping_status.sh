#!/bin/bash

# Define variables
PING_TARGET="8.8.8.8"
OUTPUT_DIR="/var/lib/node_exporter/textfile_collector"
OUTPUT_FILE="$OUTPUT_DIR/google_ping_status.prom"
METRIC_NAME="google_ping_status"

# Ensure the output directory exists
mkdir -p "$OUTPUT_DIR"

# Initialize metric value to 0 (0 means ping failed)
metric_value=0

# Perform a ping check to the target (Google's DNS server) with a timeout of 5 seconds
ping -c 1 -W 5 "$PING_TARGET" > /dev/null 2>&1

# Check if the ping command was successful
if [ $? -eq 0 ]; then
  # Set metric value to 1 if ping was successful
  metric_value=1
fi

# Write the metric in Prometheus exposition format
echo "# HELP $METRIC_NAME Indicates if the Google DNS server (8.8.8.8) is reachable (1 for reachable, 0 for unreachable)" > "$OUTPUT_FILE"
echo "# TYPE $METRIC_NAME gauge" >> "$OUTPUT_FILE"
echo "$METRIC_NAME $metric_value" >> "$OUTPUT_FILE"
