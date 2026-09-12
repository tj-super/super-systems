#!/usr/bin/env bash

# Exit on error, unset variables, and failed pipes
set -euo pipefail

usage() {
    echo "Usage: $0 -p <gmail|office365> -f <token_file_path>" >&2
    echo "Options:" >&2
    echo "  -p  Provider: 'gmail' or 'office365' (required)" >&2
    echo "  -f  Path to the token file (required)" >&2
    exit 1
}

PROVIDER=""
TOKEN_FILE=""

# Parse flags
while getopts "p:f:h" opt; do
    case "$opt" in
        p) PROVIDER="$OPTARG" ;;
        f) TOKEN_FILE="$OPTARG" ;;
        h|*) usage ;;
    esac
done

# Validate required arguments
if [[ -z "$PROVIDER" || -z "$TOKEN_FILE" ]]; then
    echo "Error: Both -p (provider) and -f (token file) are required." >&2
    usage
fi

if [[ ! -f "$TOKEN_FILE" ]]; then
    echo "Error: Token file not found at: $TOKEN_FILE" >&2
    exit 1
fi

# Read refresh token from line 2 of the token file
REFRESH_TOKEN=$(sed -n '2p' "$TOKEN_FILE" | tr -d '\r\n')

if [[ -z "$REFRESH_TOKEN" ]]; then
    echo "Error: Could not read refresh token from line 2 of $TOKEN_FILE" >&2
    exit 1
fi

# Set parameters based on provider
case "$PROVIDER" in
    gmail)
        TOKEN_URI="https://accounts.google.com/o/oauth2/token"
        CLIENT_ID="406964657835-aq8lmia8j95dhl1a2bvharmfk3t1hgqj.apps.googleusercontent.com"
        CLIENT_SECRET="kSmqreRr0qwBWJgbf5Y-PjSU"
        
        RESPONSE=$(curl -s -X POST "$TOKEN_URI" \
            -d "client_id=${CLIENT_ID}" \
            -d "client_secret=${CLIENT_SECRET}" \
            -d "refresh_token=${REFRESH_TOKEN}" \
            -d "grant_type=refresh_token")
        ;;

    office365|outlook365)
        TOKEN_URI="https://login.microsoftonline.com/common/oauth2/v2.0/token"
        CLIENT_ID="9e5f94bc-e8a4-4e73-b8be-63364c29d753"
        
        # Office365 Thunderbird client uses public client auth (no client_secret required)
        RESPONSE=$(curl -s -X POST "$TOKEN_URI" \
            -d "client_id=${CLIENT_ID}" \
            -d "grant_type=refresh_token" \
            -d "refresh_token=${REFRESH_TOKEN}" \
            -d "redirect_uri=https://localhost")
        ;;

    *)
        echo "Error: Invalid provider '$PROVIDER'. Use 'gmail' or 'office365'." >&2
        exit 1
        ;;
esac

NEW_ACCESS_TOKEN=$(echo "$RESPONSE" | jq -r '.access_token // empty')

if [[ -z "$NEW_ACCESS_TOKEN" ]]; then
    echo "Error: Failed to obtain access token." >&2
    echo "API Response: $RESPONSE" >&2
    exit 1
fi

# Optionally extract new refresh_token if rotated by Office365/Google
NEW_REFRESH_TOKEN=$(echo "$RESPONSE" | grep -oP '"refresh_token":\s*"\K[^"]+' || true)
if [[ -n "$NEW_REFRESH_TOKEN" ]]; then
    # Overwrite line 1 with new access token and line 2 with updated refresh token
    printf "%s\n%s\n" "$NEW_ACCESS_TOKEN" "$NEW_REFRESH_TOKEN" > "$TOKEN_FILE"
else
    # Overwrite line 1 with new access token while preserving existing line 2 refresh token
    printf "%s\n%s\n" "$NEW_ACCESS_TOKEN" "$REFRESH_TOKEN" > "$TOKEN_FILE"
fi

# Print ONLY the access token to stdout so imapsync captures it cleanly
echo -n "$NEW_ACCESS_TOKEN"