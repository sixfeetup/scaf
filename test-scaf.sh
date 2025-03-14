#!/usr/bin/env bash

# Default values
OUTPUT_FOLDER="/tmp/scaf-test"
TEST_DATA=""

# Usage function to display help message
usage() {
  echo "Usage: $0 -t <template_src> [-o <output_folder>] [-a <data_file>] [-h]"
  echo "  -t <template_src>   Required: Specify the source folder for the template"
  echo "  -o <output_folder>  Optional: Specify the output folder (default is /tmp/scaf-test)"
  echo "  -d <data_file>      Optional: Specify a preset answers data file"
  echo "  -h                  Show this help message"
  exit 0
}

# Parse command-line arguments
while getopts ":t:o:d:h" opt; do
  case ${opt} in
    t )
      TEMPLATE_FOLDER=$OPTARG
      ;;
    o )
      OUTPUT_FOLDER=$OPTARG
      ;;
    d )
      TEST_DATA=$OPTARG
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

# Ensure the test configuration file exists if provided
if [[ -n "$TEST_DATA" && ! -f "$TEST_DATA" ]]; then
  echo "Test config file ($TEST_DATA) not found!"
  exit 1
fi

# Clean the output folder.
rm -rf "$OUTPUT_FOLDER"

# Use local checkout.
if [[ -n "$TEST_DATA" ]]; then
  copier copy -r HEAD --trust "$TEMPLATE_FOLDER" "$OUTPUT_FOLDER" --data-file "$TEST_DATA" -q
else
  copier copy -r HEAD --trust "$TEMPLATE_FOLDER" "$OUTPUT_FOLDER"
fi
echo "Test completed using the local checkouts. Check the $OUTPUT_FOLDER for the generated project."
