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

TMP_SHARED_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_SHARED_DIR"' EXIT

TMP_SSH_DIR="$TMP_SHARED_DIR/ssh"
mkdir -p $TMP_SSH_DIR

TARGET_KEY="$TMP_SSH_DIR/ssh_host_ed25519_key"
AGE_FILE="$AGES_ROOT/ssh-host-key.age"
SOURCE_ENCRYPTED_KEY="$KEYS_ROOT/ssh/host.key"
USER_IDENTITY="$HOME/.ssh/id_ed25519"

# 1. Attempt decryption using the age identity file
DECRYPT_SUCCESS=0
if [ -f "$AGE_FILE" ] && [ -f "$USER_IDENTITY" ]; then
  echo "Attempting to decrypt $AGE_FILE using $USER_IDENTITY..."
  if age -d -i "$USER_IDENTITY" -o "$TARGET_KEY" "$AGE_FILE" 2>/dev/null; then
    DECRYPT_SUCCESS=1
    echo "Decryption successful."
  else
    echo "Age decryption failed or identity not authorized. Falling back to local key generation..."
  fi
else
  echo "Age file or local identity missing. Falling back to local key generation..."
fi

# 2. Fallback to extracting from the encrypted host.key file via interactive prompt
if [ "$DECRYPT_SUCCESS" -eq 0 ]; then
  if [ ! -f "$SOURCE_ENCRYPTED_KEY" ]; then
    echo "Error: Source encrypted key not found at $SOURCE_ENCRYPTED_KEY" >&2
    exit 1
  fi

  # Request passphrase interactively
  printf "Enter passphrase for encrypted SSH private key ($SOURCE_ENCRYPTED_KEY): "
  read -s SSH_PASSPHRASE
  echo ""

  # Copy to destination first to mutate in-place safely
  cp "$SOURCE_ENCRYPTED_KEY" "$TARGET_KEY"
  chmod 600 "$TARGET_KEY"

  # Strip password non-interactively using the inputted passphrase
  if ! ssh-keygen -p -P "$SSH_PASSPHRASE" -N "" -f "$TARGET_KEY" &>/dev/null; then
    echo "Error: Incorrect passphrase provided for $SOURCE_ENCRYPTED_KEY" >&2
    exit 1
  fi
  echo "Successfully decrypted key via passphrase extraction."
fi

# Set finalized secure permissions on the generated file
chmod 600 "$TARGET_KEY"

# Create public key from private key
ssh-keygen -y -f "$TMP_SSH_DIR/ssh_host_ed25519_key" > "$TMP_SSH_DIR/ssh_host_ed25519_key.pub"

# Build VM
nix build .#nixosConfigurations.super-station.config.system.build.vm

# Run vM
SHARED_DIR=$TMP_SHARED_DIR ./result/bin/run-nixos-vm