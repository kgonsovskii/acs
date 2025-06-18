#!/bin/bash
# Usage: ./publish.sh <runtime> <projectname> [configuration]
set -e

RUNTIME="$1"
PROJECT_NAME="$2"
CONFIG="$3"

if [ -z "$RUNTIME" ] || [ -z "$PROJECT_NAME" ]; then
  echo "Usage: $0 <runtime> <projectname> [configuration]"
  exit 1
fi

PROJECT="../src/${PROJECT_NAME^}/${PROJECT_NAME^}.csproj"
SCRIPT_NAME=$(basename "$0" .sh)
# If called from another script, use its name for output folder
if [ -n "$PUBLISH_CALLER" ]; then
  SCRIPT_NAME="$PUBLISH_CALLER"
fi
OUTPUT="output/${SCRIPT_NAME}/${PROJECT_NAME}"

dotnet publish "$PROJECT" -c "${CONFIG:-Release}" -r "$RUNTIME" --self-contained true -o "$OUTPUT"
echo "Publish complete: $OUTPUT" 