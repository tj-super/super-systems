#!/usr/bin/env bash
set -euo pipefail

KEYS_ROOT="${1:-}"
if [ -z "$KEYS_ROOT" ]; then
  echo "Error: Path to keys directory must be provided as the first argument." >&2
  exit 1
fi

AGES_ROOT="${2:-}"
if [ -z "$AGES_ROOT" ]; then
  echo "Error: Path to ages directory must be provided as the second argument." >&2
  exit 1
fi

# 1. Collect and confirm the password via masked user input
printf "Enter new user password: "
read -s PASSWORD
echo ""

printf "Confirm new user password: "
read -s PASSWORD_CONFIRM
echo ""

if [ "$PASSWORD" != "$PASSWORD_CONFIRM" ]; then
  echo "Error: Passwords do not match." >&2
  exit 1
fi

# 2. Collect and validate recipient public keys
targets=("user" "host")
AGE_RECIPIENT_ARGS=()

for type in "${targets[@]}"; do
  PUBLIC_KEY="$KEYS_ROOT/ssh/$type.pub"
  if [ -f "$PUBLIC_KEY" ]; then
    AGE_RECIPIENT_ARGS+=("-R" "$PUBLIC_KEY")
  else
    echo "Error: Required public key missing at $PUBLIC_KEY" >&2
    exit 1
  fi
done

# 3. Define target path and clear pre-existing secret file
TARGET_SECRET="$AGES_ROOT/user-password.age"
if [ -f "$TARGET_SECRET" ]; then
  rm "$TARGET_SECRET"
fi

# 4. Generate the SHA-512 hash and encrypt it directly via age
# mkpasswd outputs the modular crypt format hash which is piped directly to age
mkpasswd -m sha-512 "$PASSWORD" | age "${AGE_RECIPIENT_ARGS[@]}" -o "$TARGET_SECRET"

echo "Success: New password hash encrypted and saved to $TARGET_SECRET"