#!/bin/bash
# Usage: ./linux-arm.sh [projectname] [configuration]
#
# Well-known .NET 8 RIDs (Runtime Identifiers) for reference:
#   win-x86    (Windows 32-bit)
#   win-x64    (Windows 64-bit)
#   linux-x64  (Linux 64-bit)
#   linux-arm  (Linux ARM 32-bit)
#   linux-arm64 (Linux ARM 64-bit)
#   osx-x64    (macOS Intel 64-bit)
#   osx-arm64  (macOS Apple Silicon)
#
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}" )" && pwd)"
export PUBLISH_CALLER=$(basename "$0" .sh)

PROJECT_NAME="${1:-${PUBLISH_PROJECT:-monolith}}"
CONFIG="${2:-Release}"

"$DIR/publish.sh" linux-arm "$PROJECT_NAME" "$CONFIG" 