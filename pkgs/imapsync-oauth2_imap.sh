#!/usr/bin/env bash
set -euo pipefail

CALLER_PWD="$PWD"
OAUTH2_DIR="@oauth2Dir@"
PERL_BIN="@perlBin@"

# Resolve relative paths for --token_file or positional token paths relative to $CALLER_PWD
args=()
for arg in "$@"; do
  if [[ "$arg" =~ ^--token_file=(.*)$ ]]; then
    val="${BASH_REMATCH[1]}"
    if [[ "$val" != /* ]]; then
      val="$CALLER_PWD/$val"
    fi
    args+=("--token_file=$val")
  else
    args+=("$arg")
  fi
done

# Change directory to access relative SSL certs/assets
cd "$OAUTH2_DIR"

# Execute Perl script with absolute token path and local assets in $PWD
exec "$PERL_BIN" "$OAUTH2_DIR/oauth2_imap" "${args[@]}"