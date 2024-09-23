#!/bin/bash

# Define variables
OUTPUT_DIR="/var/lib/node_exporter/textfile_collector"
OUTPUT_FILE="$OUTPUT_DIR/iptables_line_count.prom"
METRIC_NAME="iptables_line_count"

# Ensure the output directory exists
mkdir -p $OUTPUT_DIR

# Full path to iptables
IPTABLES_CMD="/usr/sbin/iptables"

# Count the number of lines in iptables output
line_count=$($IPTABLES_CMD -L | wc -l)

# Write the metric in Prometheus exposition format
echo "# HELP $METRIC_NAME Number of lines in iptables -L output" > $OUTPUT_FILE
echo "# TYPE $METRIC_NAME gauge" >> $OUTPUT_FILE
echo "$METRIC_NAME $line_count" >> $OUTPUT_FILE
