#!/bin/bash

SCAF_SCRIPT_URL="https://raw.githubusercontent.com/sixfeetup/cookiecutter-sixiedjango/rcompaan/157-simplify-install/scaf"
TEMP_DOWNLOAD="./scaf"
DESTINATION="/usr/local/bin/scaf"

# Download scaf to the current directory
echo "Downloading scaf ..."
curl -L $SCAF_SCRIPT_URL -o $TEMP_DOWNLOAD

# Check if the download was successful
if [ -f "$TEMP_DOWNLOAD" ]; then
    # Make the script executable
    chmod +x $TEMP_DOWNLOAD

    # Move the script to the final destination using sudo
    echo "Moving scaf to $DESTINATION..."
    sudo mv $TEMP_DOWNLOAD $DESTINATION

    # Check if the move was successful
    if [ -f "$DESTINATION" ]; then
        echo "scaf installed successfully at $DESTINATION"
    else
        echo "Failed to move scaf to the destination."
        exit 1
    fi
else
    echo "Failed to download scaf."
    exit 1
fi
