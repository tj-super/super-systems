{
  inputs,
  pkgs,
  system,
  ...
}:
with inputs;
let
  run-vm = pkgs.writeShellApplication {
    name = "run-vm";

    runtimeInputs = [
      pkgs.age
      pkgs.nix
      pkgs.openssh
    ];

    text = ''
      exec ${./scripts/run-vm.sh} "./keys" "./ages"
    '';
  };

  set-user-password = pkgs.writeShellApplication {
    name = "set-user-password";

    runtimeInputs = [
      pkgs.nano
      pkgs.age
    ];

    text = ''
      exec ${./scripts/set-user-password.sh} "./keys" "./ages"
    '';
  };

  sync-ssh-age-keys = pkgs.writeShellApplication {
    name = "sync-ssh-age-keys";

    runtimeInputs = [
      pkgs.age
      pkgs.openssh
    ];

    text = ''
      exec ${./scripts/sync-ssh-age-keys.sh} "./keys" "./ages"
    '';
  };

  scripts = [
    run-vm
    set-user-password
    sync-ssh-age-keys
  ];
in

pkgs.mkShell {
  buildInputs = let
    disko = inputs.disko.packages.${system}.default;
  in
    with pkgs;
    scripts
    ++ [
      disko
      nixd
      nixfmt
    ];
}
