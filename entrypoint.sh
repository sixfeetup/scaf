#!/usr/bin/env sh
set -e

echo "Starting entrypoint script..."

# Check if HOST_UID and HOST_GID are provided
if [ -z "$HOST_UID" ]; then
    echo "ERROR: please set HOST_UID" >&2
    exit 1
else
    echo "HOST_UID provided: $HOST_UID"
fi

if [ -z "$HOST_GID" ]; then
    echo "ERROR: please set HOST_GID" >&2
    exit 1
else
    echo "HOST_GID provided: $HOST_GID"
fi

# Function to check if a group with the given GID already exists
group_exists_with_gid() {
    echo "Checking if user with UID $1 exists..."
    getent group | cut -d: -f3 | grep -q "^$1$"
}

# Function to check if a user with the given UID already exists
user_exists_with_uid() {
    echo "Checking if user with UID $1 exists..."
    getent passwd | cut -d: -f3 | grep -q "^$1$"
}

# Function to check if the scaf user already has the target UID
scaf_has_uid() {
    echo "Checking if scaf has UID $1..."
    [ "$(id -u scaf)" -eq "$1" ]
}

# Function to check if the scaf group already has the target GID
scaf_has_gid() {
    echo "Checking if scaf group has GID $1..."
    [ "$(getent group scaf | cut -d: -f3)" -eq "$1" ]
}

# Modify the scaf user account to match the host user, adjusting for existing GID
if group_exists_with_gid "$HOST_GID"; then
    echo "Group with GID $HOST_GID exists."
    if ! scaf_has_gid "$HOST_GID"; then
        existing_group=$(getent group | awk -F: "\$3 == $HOST_GID { print \$1 }")
        echo "Existing group with GID $HOST_GID: $existing_group"
        usermod -g "$existing_group" scaf
        echo "Assigned existing group $existing_group to scaf."
    else
        echo "scaf already in the correct group."
    fi
else
    echo "Group with GID $HOST_GID does not exist, attempting to modify scaf group."
    groupmod -g "$HOST_GID" scaf
    echo "Modified scaf group to GID $HOST_GID."
fi

if ! scaf_has_uid "$HOST_UID"; then
    if user_exists_with_uid "$HOST_UID"; then
        echo "ERROR: UID '$HOST_UID' already exists" >&2
        exit 1
    else
        echo "Modifying scaf UID to $HOST_UID."
        usermod -u "$HOST_UID" scaf
        echo "Modified scaf UID to $HOST_UID."
    fi
else
    echo "scaf already has the UID $HOST_UID."
fi

echo "Finalizing: Dropping privileges and executing command..."
# Drop privileges and execute the next container command, or 'sh' if not specified
if [ "$#" -gt 0 ]; then
    echo "Executing command: $@"
    su-exec scaf "$@"
else
    echo "No command specified, launching shell."
    su-exec scaf sh
fi
