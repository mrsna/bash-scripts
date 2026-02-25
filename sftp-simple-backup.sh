#!/bin/bash
set -euo pipefail

# This script creates a backup of a specified directory from a remote server 
# using SFTP. It generates a timestamped folder in the local backup location, 
# retrieves the contents of the remote directory, and removes any local files 
# that are older than a specified number of days to free up space.

# Configuration:
# - Set PASSWORD_AUTH to true for password authentication or false for key authentication.
# - Adjust the following parameters as needed for your setup:
#   - PASSWORD: The password for SFTP connection (if PASSWORD_AUTH is true).
#   - PORT: The port for SFTP connection.
#   - USER: The username for SFTP connection.
#   - SERVER: The server address for SFTP connection.
#   - REMOTE_DIR: The remote directory to backup.
#   - LOCAL_BACKUP_DIR: The local directory to store backups.
#   - PRIVATE_KEY: The path to the private key (if PASSWORD_AUTH is false).
#   - DAYS_TO_KEEP: The number of days to keep local files; older files will be deleted.

# Configuration variables
PASSWORD_AUTH=true  # Set to true for password, false for key-based authentication
PASSWORD="YOUR_PASSWORD"  # Only needed if PASSWORD_AUTH is true
PORT="YOUR_PORT"
USER="YOUR_USER"
SERVER="YOUR_SERVER"
REMOTE_DIR="remote_directory"
LOCAL_BACKUP_DIR="/path/to/location"
PRIVATE_KEY="${HOME}/.ssh/id_rsa"  # Path to your SSH private key
DAYS_TO_KEEP=14  # Number of days to keep local files

NOW=$( date '+%F_%H-%M' )
BACKUP_DIR="${LOCAL_BACKUP_DIR}/backup_${NOW}"

# Create backup directory and check for errors
if mkdir -p "${BACKUP_DIR}"; then
    echo "Backup directory created at: ${BACKUP_DIR}"
else
    echo "Error: Failed to create backup directory" >&2
    exit 1
fi

# Perform SFTP transfer and check for errors
if $PASSWORD_AUTH; then
    if sshpass -p "${PASSWORD}" sftp -oPort="${PORT}" -oStrictHostKeyChecking=accept-new "${USER}@${SERVER}:${REMOTE_DIR}/" <<EOF
    get -R world "${BACKUP_DIR}/"
    exit
EOF
    then
        echo "Files successfully retrieved from remote directory."
    else
        echo "Error: SFTP transfer failed" >&2
        exit 1
    fi
else
    if sftp -i "${PRIVATE_KEY}" -oPort="${PORT}" -oStrictHostKeyChecking=accept-new "${USER}@${SERVER}:${REMOTE_DIR}/" <<EOF
    get -R world "${BACKUP_DIR}/"
    exit
EOF
    then
        echo "Files successfully retrieved from remote directory."
    else
        echo "Error: SFTP transfer failed" >&2
        exit 1
    fi
fi

# Clean up old files and check for errors
if find "${LOCAL_BACKUP_DIR}/" -mindepth 1 -mtime +"${DAYS_TO_KEEP}" -delete; then
    echo "Old files older than ${DAYS_TO_KEEP} days deleted successfully."
else
    echo "Error: Failed to delete old files" >&2
    exit 1
fi

echo "Backup completed successfully!"

