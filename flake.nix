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
    wezterm = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:/wezterm/wezterm?dir=nix";
    };
  };

  outputs = {disko, nixpkgs, ...} @ inputs: let
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

    nixosConfigurations.default = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {inherit inputs system;};
      modules = [
        disko.nixosModules.disko
        ./config.nix
        ./disko.nix
      ];
    };
  };
}
