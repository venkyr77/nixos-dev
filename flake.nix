{
  inputs = {
    flake-compat.url = "github:/edolstra/flake-compat";
    flake-parts.url = "github:hercules-ci/flake-parts";
    git-hooks = {
      inputs = {
        flake-compat.follows = "flake-compat";
        nixpkgs.follows = "nixpkgs";
      };
      url = "github:cachix/git-hooks.nix";
    };
    hercules-ci-effects = {
      inputs = {
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
      };
      url = "github:hercules-ci/hercules-ci-effects";
    };
    neovim-nightly = {
      inputs = {
        flake-compat.follows = "flake-compat";
        flake-parts.follows = "flake-parts";
        git-hooks.follows = "git-hooks";
        hercules-ci-effects.follows = "hercules-ci-effects";
        nixpkgs.follows = "nixpkgs";
      };
      url = "github:nix-community/neovim-nightly-overlay";
    };
    nfl = {
      inputs = {
        flake-compat.follows = "flake-compat";
        flake-parts.follows = "flake-parts";
        git-hooks.follows = "git-hooks";
        hercules-ci-effects.follows = "hercules-ci-effects";
        neovim-nightly.follows = "neovim-nightly";
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
  };

  outputs = {
    nixos-wsl,
    nixpkgs,
    ...
  } @ inputs: let
    system = "x86_64-linux";
  in {
    nixosConfigurations.default = nixpkgs.lib.nixosSystem {
      modules = [
        nixos-wsl.nixosModules.default
        ./config.nix
      ];
      specialArgs = {inherit inputs system;};
      inherit system;
    };
  };
}
