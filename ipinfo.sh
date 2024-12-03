#!/bin/bash

# ANSI color codes
BOLD_GREEN="\e[1;32m"
YELLOW="\e[33m"
RESET="\e[0m"

# Fetch JSON data from ipinfo.io
DATA=$(curl -s --connect-timeout 5 https://ipinfo.io || echo "")

# Check if DATA is non-empty
if [[ -n "$DATA" ]]; then
  # Parse JSON keys
  IP=$(echo "$DATA" | jq -r '.ip // empty')
  CITY=$(echo "$DATA" | jq -r '.city // empty')
  ORG=$(echo "$DATA" | jq -r '.org // empty')
  LOC=$(echo "$DATA" | jq -r '.loc // empty')

  # Ensure at least one field is not empty
  if [[ -n "$IP" || -n "$CITY" || -n "$ORG" || -n "$LOC" ]]; then
    # Format the location as a Google Maps link
    MAP_URL="https://www.google.com/maps/place/$LOC"

    # Print data with colored output
    echo -e "${BOLD_GREEN}IP:${RESET} ${YELLOW}$IP${RESET} | \
${BOLD_GREEN}City:${RESET} ${YELLOW}$CITY${RESET} | \
${BOLD_GREEN}Org:${RESET} ${YELLOW}$ORG${RESET} | \
${BOLD_GREEN}Location:${RESET} ${YELLOW}$MAP_URL${RESET}"
  fi
fi
