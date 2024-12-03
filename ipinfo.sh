#!/bin/bash

# Fetch IP from ipinfo.io
IP=$(curl -s --connect-timeout 5 https://ipinfo.io/ip || echo "")

# Check if IP is non-empty
if [[ -n "$IP" ]]; then
  echo "$IP"
fi
