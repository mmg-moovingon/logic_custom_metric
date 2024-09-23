PORT=80  # Change to the port you want to check
METRICS_FILE="/var/lib/node_exporter/textfile_collector/application_status.prom"
METRIC_NAME="application_status"

# Initialize status to 0 (not running or not listening)
status=0

# Check if the service is running
service_status=$($SERVICE_SCRIPT status 2>&1)  # Capture both stdout and stderr
exit_code=$?  # Capture exit code
echo "Raw Service Status Output: '$service_status'"  # Raw output for debugging
echo "Exit Code: $exit_code"  # Debug exit code

# Trim whitespace
service_status=$(echo "$service_status" | xargs)
echo "Trimmed Service Status Output: '$service_status'"  # Trimmed output

# Check if the output indicates the service is running
if [[ $service_status == *"Process is running"* ]]; then
    echo "Hello World"  # Debug output

    # Check if the service is listening on port 80
    if ss -tuln | grep -q ":$PORT "; then
        echo "Service is listening on port $PORT."  # Debug output

        # Check if the process is a Java process
        if lsof -i :$PORT | grep -qi "java"; then
            echo "Service is a Java process."  # Debug output
            status=1  # Both conditions are met
        else
            echo "Service is listening on port $PORT, but not a Java process."  # Debug output
        fi
    else
        echo "Service is not listening on port $PORT."  # Debug output
    fi
else
    echo "$SERVICE_NAME is not running."  # Debug output
fi

# Output the metric to the specified file
echo "# HELP $METRIC_NAME 1 if $SERVICE_NAME is running and listening on port $PORT as a Java process, 0 otherwise" > $METRICS_FILE
echo "# TYPE $METRIC_NAME gauge" >> $METRICS_FILE
echo "$METRIC_NAME{service=\"$SERVICE_NAME\"} $status" >> $METRICS_FILE
