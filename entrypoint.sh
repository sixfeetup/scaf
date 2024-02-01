#!/usr/bin/env sh
set -e

# Check if HOST_UID and HOST_GID are provided
if [ -z "$HOST_UID" ]; then
    echo "ERROR: please set HOST_UID" >&2
    exit 1
fi

if [ -z "$HOST_GID" ]; then
    echo "ERROR: please set HOST_GID" >&2
    exit 1
fi

# Function to check if a group with the given GID already exists
group_exists_with_gid() {
    getent group | cut -d: -f3 | grep -q "^$1$"
}

# Modify the scaf user account to match the host user, adjusting for existing GID
if group_exists_with_gid "$HOST_GID"; then
    # Find the group name with the target GID
    existing_group=$(getent group | awk -F: "\$3 == $HOST_GID { print \$1 }")

    # Use the existing group for the scaf user
    usermod -g "$existing_group" scaf
else
    # If GID does not exist, modify the scaf group to match HOST_GID
    groupmod -g "$HOST_GID" scaf
fi

# Modify the scaf user to match HOST_UID
usermod -u "$HOST_UID" scaf

# Drop privileges and execute the next container command, or 'sh' if not specified
if [ "$#" -gt 0 ]; then
    su-exec scaf "$@"
else
    su-exec scaf sh
fi
