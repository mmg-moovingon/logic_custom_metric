for server in moovingon@logic{2,3,7..13,17..31}.rtbsrv.com; do
    echo "Copying to $server..."
    scp -i ~/.ssh/mmg-keys/moovingon.pem -r ~/prometheus_custom_metrics "$server:/tmp" || echo "Failed to copy to $server"
done
