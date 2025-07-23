#!/bin/bash

# Auto-detect sudo only if not root
SUDO_CMD=""
if [ "$EUID" -ne 0 ]; then
  SUDO_CMD="sudo"
fi

# Show help if no arguments
if [ -z "$1" ]; then
  echo "Usage: findpath <name> [f|d]"
  echo "  f = search for file (default)"
  echo "  d = search for directory"
  exit 1
fi

NAME="$1"
TYPE="${2:-f}"  # Default to file

# Validate type input
if [[ "$TYPE" != "f" && "$TYPE" != "d" ]]; then
  echo "❌ Error: Invalid type '$TYPE'"
  echo "Allowed types: 'f' for file, 'd' for directory"
  exit 1
fi

# Perform the search
if [[ "$TYPE" == "f" ]]; then
  echo "🔍 Searching for file: $NAME"
  $SUDO_CMD find / -type f -iname "$NAME" 2>/dev/null
else
  echo "📂 Searching for directory: $NAME"
  $SUDO_CMD find / -type d -iname "$NAME" 2>/dev/null
fi
