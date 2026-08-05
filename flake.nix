{
  description = "super-systems";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-26.05";

    disko = {
      url = "github:nix-community/disko?ref=v1.13.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix?ref=0.15.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.1.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      keys = import ./keys/keys.nix;

      profile = (import ./profile/home.nix) {
        inherit inputs;

        username = "super";
        stateVersion = "26.05";
      };
    in
    {
      lib.pubKeys.ssh = {
        users.super = builtins.readFile ./keys/ssh/user.pub;
        hosts.super-station = builtins.readFile ./keys/ssh/host.pub;
      };
      
      devShells.${system}.default = import ./shell/dev-shell.nix {
        inherit
          self
          pkgs
          inputs
          system
          ;
      };

      nixosConfigurations.super-station = import ./host/station/nixos-system.nix {
        inherit
          self
          keys
          inputs
          system
          profile
          ;

        stateVersion = "26.05";

        modules = [
          {
            networking.hostName = "super-station";
            time.timeZone = "America/Chicago";
          }
        ];
      };
    };
}
