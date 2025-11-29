{
  inputs = {
    disko = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:/nix-community/disko";
    };
    nfl = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:/venkyr77/neovim-flake";
    };
    nixpkgs.url = "github:/NixOS/nixpkgs/nixpkgs-unstable";
    rust-overlay = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:/oxalica/rust-overlay";
    };
    wezterm = {
      inputs = {
        nixpkgs.follows = "nixpkgs";
        rust-overlay.follows = "rust-overlay";
      };
      url = "github:/wezterm/wezterm?dir=nix";
    };
  };

  outputs = {
    disko,
    nixpkgs,
    ...
  } @ inputs: let
    system = "x86_64-linux";
  in {
    formatter.${system} = let
      pkgs = nixpkgs.legacyPackages.${system};
    in
      pkgs.writeShellApplication {
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

    nixosConfigurations.dev = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {inherit inputs system;};
      modules = [
        disko.nixosModules.disko
        ./modules/base.nix
        ./modules/disko.nix
        ./modules/hardware.nix
        ./modules/programs.nix
        ./modules/users.nix
      ];
    };
  };
}
