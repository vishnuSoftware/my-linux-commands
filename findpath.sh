#!/bin/bash

# Colors
RED='\033[1;31m'
GREEN='\033[1;32m'
BLUE='\033[1;34m'
YELLOW='\033[1;33m'
RESET='\033[0m'

# Auto-detect sudo
SUDO_CMD=""
if [ "$EUID" -ne 0 ]; then
  SUDO_CMD="sudo"
fi

# Help message
if [ -z "$1" ]; then
  echo -e "${YELLOW}Usage:${RESET} findpath <name> [f|d]"
  echo -e "  ${BLUE}f${RESET} = search for file (default)"
  echo -e "  ${BLUE}d${RESET} = search for directory"
  exit 1
fi

NAME="$1"
TYPE="${2:-f}"

# Validate type
if [[ "$TYPE" != "f" && "$TYPE" != "d" ]]; then
  echo -e "${RED}❌ Error:${RESET} Invalid type '${TYPE}'"
  echo -e "Allowed types: '${BLUE}f${RESET}' for file, '${BLUE}d${RESET}' for directory"
  exit 1
fi

# Perform search
if [[ "$TYPE" == "f" ]]; then
  echo -e "${GREEN}🔍 Searching for file:${RESET} $NAME"
  RESULTS=$($SUDO_CMD find / -type f -iname "$NAME" 2>/dev/null)
else
  echo -e "${GREEN}📂 Searching for directory:${RESET} $NAME"
  RESULTS=$($SUDO_CMD find / -type d -iname "$NAME" 2>/dev/null)
fi

# Show results or not found
if [[ -z "$RESULTS" ]]; then
  echo -e "${RED}❗ No matches found for:${RESET} $NAME"
else
  echo -e "${BLUE}✅ Found:${RESET}"
  echo "$RESULTS" | while read -r line; do
    echo -e "  ${YELLOW}$line${RESET}"
  done
fi
