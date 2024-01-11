#!/usr/bin/env sh
set -e

if [[ -z "$HOST_UID" ]]; then
    echo "ERROR: please set HOST_UID" >&2
    exit 1
fi
if [[ -z "$HOST_GID" ]]; then
    echo "ERROR: please set HOST_GID" >&2
    exit 1
fi

# Modify a scaf user account to match the host user.
groupmod -g "$HOST_GID" scaf
usermod -u "$HOST_UID" scaf

# Drop privileges and execute next container command, or 'bash' if not specified.
if [[ $# -gt 0 ]]; then
    su-exec scaf "$@"
else
    su-exec scaf sh
fi
