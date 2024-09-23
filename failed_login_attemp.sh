#!/bin/bash

OUTPUT_DIR="/var/lib/node_exporter/textfile_collector"
LOG_FILE="/var/log/auth.log"
OUTPUT_FILE="$OUTPUT_DIR/failed_attempts.prom"

# Ensure output directory exists
mkdir -p $OUTPUT_DIR

# Count the failed login attempts
attempts=$(tail -100 $LOG_FILE | egrep -i 'refused|failed|failure' | wc -l)

# Write the result in Prometheus exposition format
echo "# HELP failed_login_attempts_total Number of failed login attempts" > $OUTPUT_FILE
echo "# TYPE failed_login_attempts_total gauge" >> $OUTPUT_FILE
echo "failed_login_attempts_total $attempts" >> $OUTPUT_FILE
