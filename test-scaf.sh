#!/usr/bin/env bash

# Default values
OUTPUT_FOLDER="/tmp/scaf-test"
TEST_CONFIG="./test-configs/nextjs-django-github.yaml"

# Usage function to display help message
usage() {
  echo "Usage: $0 [-o <output_folder>] [-c <config_file>] [-h]"
  echo "  -o <output_folder>  Optional: Specify the output folder (default is /tmp/scaf-test)"
  echo "  -c <config_file>    Optional: Specify the config file (default is $TEST_CONFIG)"
  echo "  -h                  Show this help message"
  exit 0
}

# Parse command-line arguments
while getopts ":o:c:h" opt; do
  case ${opt} in
    o )
      OUTPUT_FOLDER=$OPTARG
      ;;
    c )
      TEST_CONFIG=$OPTARG
      ;;
    h )
      usage
      ;;
    \? )
      echo "Invalid option: -$OPTARG" 1>&2
      usage
      ;;
    : )
      echo "Option -$OPTARG requires an argument." 1>&2
      usage
      ;;
  esac
done

# Dynamically set the SCAF_ROOT to the directory where this script is located.
SCAF_ROOT=$(dirname "$(realpath "$0")")

# Ensure the test configuration file exists.
if [[ ! -f "$TEST_CONFIG" ]]; then
  echo "Test config file ($TEST_CONFIG) not found!"
  exit 1
fi

# Clean the output folder.
rm -rf "$OUTPUT_FOLDER"

# Use local checkout.
cookiecutter "$SCAF_ROOT" --no-input --config-file "$TEST_CONFIG" -o "$OUTPUT_FOLDER" -v
echo "Test completed using the local checkout. Check the $OUTPUT_FOLDER for the generated project."
