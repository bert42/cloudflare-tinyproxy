#!/bin/bash
# Launch browser with proxy settings
# Usage: ./launch-browser.sh <proxy-host> [port]
#
# Examples:
#   ./launch-browser.sh myserver.com
#   ./launch-browser.sh 192.168.1.100 8080

PROXY_HOST="${1:?Usage: $0 <proxy-host> [port]}"
PROXY_PORT="${2:-61234}"
PROXY_URL="http://${PROXY_HOST}:${PROXY_PORT}"

echo "Launching browser with proxy: ${PROXY_URL}"

# Detect OS and browser
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    if [ -d "/Applications/Google Chrome.app" ]; then
        open -na "Google Chrome" --args \
            --proxy-server="${PROXY_URL}" \
            --user-data-dir="/tmp/chrome-proxy-$$" \
            --no-first-run
    elif [ -d "/Applications/Firefox.app" ]; then
        echo "Firefox requires manual proxy configuration in preferences"
        echo "Set HTTP Proxy to: ${PROXY_HOST}:${PROXY_PORT}"
        open -a "Firefox"
    else
        echo "No supported browser found (Chrome or Firefox)"
        exit 1
    fi
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux
    if command -v google-chrome &> /dev/null; then
        google-chrome \
            --proxy-server="${PROXY_URL}" \
            --user-data-dir="/tmp/chrome-proxy-$$" \
            --no-first-run &
    elif command -v chromium-browser &> /dev/null; then
        chromium-browser \
            --proxy-server="${PROXY_URL}" \
            --user-data-dir="/tmp/chrome-proxy-$$" \
            --no-first-run &
    elif command -v firefox &> /dev/null; then
        echo "Firefox requires manual proxy configuration in preferences"
        echo "Set HTTP Proxy to: ${PROXY_HOST}:${PROXY_PORT}"
        firefox &
    else
        echo "No supported browser found (Chrome, Chromium, or Firefox)"
        exit 1
    fi
else
    echo "Unsupported OS: $OSTYPE"
    echo "Configure your browser manually with proxy: ${PROXY_URL}"
    exit 1
fi

echo "Browser launched. All traffic will route through ${PROXY_URL}"
