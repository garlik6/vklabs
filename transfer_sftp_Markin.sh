#!/bin/bash


LOCAL_DIR="/var/log"
PATH_TO_SSH="/home/user/.ssh/id_rsa" #change to current pc

# number of files to create
NUM_FILES=5

# maximum age of files in seconds (1 week)
MAX_AGE=$((60)) # 604800 - one week in seconds

REMOTE_HOST="10.169.0.137" #change to "192.168.2.78"
REMOTE_USER="osboxes" #change to "admini"
REMOTE_DIR="logs" #create dir on remote server

# loop for create log files
for i in $(seq 1 $NUM_FILES); do
    FILENAME=$LOCAL_DIR/"logfile_$i"$(date +"_%Y-%m-%d-%H:%M:%S").log
    echo "VK SRE log file number $i" >> "$FILENAME"
done

# Transfer files to remote server using SFTP
sftp -i $PATH_TO_SSH "$REMOTE_USER@$REMOTE_HOST:$REMOTE_DIR" <<EOF
put $LOCAL_DIR/*.log
exit
EOF

# Remove files older than the maximum age on the remote server
ssh -i $PATH_TO_SSH "$REMOTE_USER@$REMOTE_HOST" "find $REMOTE_DIR/*.log -mtime +$(($MAX_AGE/86400)) -delete"

