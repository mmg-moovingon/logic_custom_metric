#!/bin/bash

# Define variables
SERVICE_NAME="logic"
SERVICE_SCRIPT="/etc/init.d/$SERVICE_NAME"
PORT=80  # Change to the port you want to check, in this case, port 80
METRICS_FILE="/var/lib/node_exporter/textfile_collector/application_status.prom"
METRIC_NAME="application_status"

# Initialize status to 0 (not running or not listening)
status=0

# Check if the service is running
service_status=$($SERVICE_SCRIPT status)

if [[ $service_status == *"is Running"* ]]; then
    # Check if the service is listening on port 80 and if it's a Java process
    if ss -tuln | grep -q ":$PORT " && lsof -i :$PORT | grep -qi "java"; then
        status=1  # Both conditions are met: the service is running and it's a Java process listening on port 80
    fi
fi

# Output the metric to the specified file
echo "# HELP $METRIC_NAME 1 if $SERVICE_NAME is running and listening on port $PORT as a Java process, 0 otherwise" > $METRICS_FILE
echo "# TYPE $METRIC_NAME gauge" >> $METRICS_FILE
echo "$METRIC_NAME{service=\"rtb_server\"} $status" >> $METRICS_FILE
