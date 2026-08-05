{
  description = "super-systems";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-26.05";

    disko = {
      url = "github:nix-community/disko?ref=v1.13.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix/main";
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

      profile = (import ./profile/home.nix) {
        inherit inputs;

        username = "super";
        stateVersion = "26.05";
      };

      satellite = import ./host/satellite/host.nix {
        inherit
          self
          system
          inputs
          profile
          ;
      };

      station = import ./host/station/host.nix {
        inherit
          self
          system
          inputs
          profile
          ;
      };
    in
    {
      lib.pubKeys.ssh = {
        users.super = profile.publicKey;
        hosts.satellite = satellite.publicKey;
        hosts.station = station.publicKey;
      };

      devShells.${system}.default = import ./shell/dev-shell/default.nix {
        inherit
          self
          pkgs
          inputs
          system
          ;

        hosts = {
          inherit satellite;
          inherit station;
        };
      };

      nixosConfigurations.satellite = satellite.nixosConfiguration;
      nixosConfigurations.station = station.nixosConfiguration;
    };
}
