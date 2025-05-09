{
  inputs = {
    disko = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:/nix-community/disko";
    };
    flake-compat.url = "github:/edolstra/flake-compat";
    nfl = {
      inputs = {
        flake-compat.follows = "flake-compat";
        nixpkgs.follows = "nixpkgs";
      };
      url = "github:/venkyr77/neovim-flake";
    };
    nixos-wsl = {
      inputs = {
        flake-compat.follows = "flake-compat";
        nixpkgs.follows = "nixpkgs";
      };
      url = "github:nix-community/NixOS-WSL/main";
    };
    nixpkgs.url = "github:/NixOS/nixpkgs/nixpkgs-unstable";
    wezterm = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:/wezterm/wezterm?dir=nix";
    };
  };

  outputs = {
    disko,
    nixos-wsl,
    nixpkgs,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    formatter.${system} = pkgs.writeShellApplication {
      name = "format";
      runtimeInputs = builtins.attrValues {
        inherit (pkgs) alejandra deadnix fd statix;
      };
      text = ''
        fd "$@" -t f -e nix -x statix fix -- '{}'
        fd "$@" -t f -e nix -X deadnix -e -- '{}'
        fd "$@" -t f -e nix -X alejandra '{}'
      '';
    };

    nixosConfigurations = {
      dev = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {inherit inputs system;};
        modules = [
          disko.nixosModules.disko
          ./hosts/dev
        ];
      };
      wsl = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {inherit inputs system;};
        modules = [
          nixos-wsl.nixosModules.default
          ./hosts/wsl
        ];
      };
    };
  };
}
