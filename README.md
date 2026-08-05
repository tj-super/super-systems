# super laptop

## SSH Keys and AGE Secrets

User and host SSH keys are stored under `keys` and encrypted with a passphrase.  All other secrets and keys are encrypted via AGE using the SSH keys.

When running as a virtual machine, the keys are decrypted to a `tmp` directory and mounted to the VM using QEMU's `SHARED_DIR` environment variable.  An activation script installs these into the virtual machine before `agenix` decryption takes place.

After changing either the user or host SSH key, run `sync-ssh-age-keys` to update the AGE versions of the keys. Currently, re-encryption of other AGE keys using the new SSH key(s) is unhandled.

## Scripts

> When modifying scripts, use `direnv reload` to load the new versions.

- `run-vm` - Build and run the configuration as a local virtual machine.
- `set-user-password` - Change the AGE-encrypted user account password.
- `sync-ssh-age-keys` - Re-encrypt SSH AGE secrets after changing SSH keys.

## TODO

- Rewrite bash scripts in Bun
- Change key names to `id_ed25519` and `ssh_host_ed25519_key`
  * Remove `ssh` subdirectory from `keys` as this will only ever contain SSH keys
    * AGE secrets will be used for every other kind of key/secret
- Handle re-encryption of AGE secrets after changing SSH keys via scripts.
- Migrate hyprland configuration from hyprlang to lua (after next NixOS release or something)
- install ublock origin via firefox module
- add bluetooth support
- enable lanzaboote