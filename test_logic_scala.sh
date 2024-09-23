#!/bin/bash

# Define variables
PORT=80
HEALTHCHECK_URL="http://localhost/srv/logic/?hash=l6ef5a"
OUTPUT_DIR="/var/lib/node_exporter/textfile_collector"
OUTPUT_FILE="$OUTPUT_DIR/test_logic_scala.prom"
METRIC_NAME="test_logic_scala"

# Initialize status to 0 (not healthy)
status=0

# Check if port 80 is up
if ss -tuln | grep -q ":$PORT "; then
    # Check if the healthcheck URL returns 1
    response=$(wget -qO- "$HEALTHCHECK_URL")
    
    if [[ $response == "1" ]]; then
        status=1  # Both port 80 is up and the healthcheck returned 1
    fi
else
    echo "Port $PORT is not open."
fi


# Output the metric to the specified file
echo "# HELP $METRIC_NAME 1 if port 80 is up and healthcheck returns 1, 0 otherwise" > $OUTPUT_FILE
echo "# TYPE $METRIC_NAME gauge" >> $OUTPUT_FILE
echo "$METRIC_NAME{service=\"rtb_test_bidder\"} $status" >> $OUTPUT_FILE
