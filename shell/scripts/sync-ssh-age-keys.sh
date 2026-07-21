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

# 1. Create a secure temporary directory and guarantee its removal on exit
TMP_DIR=$(mktemp -d)
trap 'rm -rf "$TMP_DIR"' EXIT

# 2. Collect SSH key passphrase from interactive user prompt securely
printf "Enter passphrase for encrypted SSH private keys: "
read -s SSH_PASSPHRASE
echo ""

# Define the targets to process
targets=(
  "host"
  "user"
)

# 3. Pre-collect and validate all public keys to build the recipient arguments
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

# Loop through targets to decrypt and re-encrypt
for type in "${targets[@]}"; do
  ENCRYPTED_KEY="$KEYS_ROOT/ssh/$type.key"
  TEMP_DECRYPTED_KEY="$TMP_DIR/$type.key"
  OUTPUT_AGE_FILE="$AGES_ROOT/ssh-$type-key.age"

  if [ ! -f "$ENCRYPTED_KEY" ]; then
    echo "Warning: Skipped '$type' - private key not found at $ENCRYPTED_KEY"
    continue
  fi

  echo "Processing $type SSH key..."

  # Copy the encrypted key to tmp, then use ssh-keygen to strip the password
  cp "$ENCRYPTED_KEY" "$TEMP_DECRYPTED_KEY"
  chmod 600 "$TEMP_DECRYPTED_KEY"
  
  if ! ssh-keygen -p -P "$SSH_PASSPHRASE" -N "" -f "$TEMP_DECRYPTED_KEY" &>/dev/null; then
    echo "Error: Incorrect passphrase provided for $ENCRYPTED_KEY" >&2
    exit 1
  fi

  # 4. Encrypt the passwordless private key using all accumulated public keys
  age "${AGE_RECIPIENT_ARGS[@]}" -o "$OUTPUT_AGE_FILE" "$TEMP_DECRYPTED_KEY"

  echo "Successfully created $OUTPUT_AGE_FILE"
done