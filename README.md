# nixos-dev

Personal nixos systems for development

1. A dedicated system
1. A WSL based system

## Bootstrapping on dedicated system

1. Start the ISO installer, close it
1. Open the terminal
1. `git clone https://github.com/venkyr77/nixos-dev/git`
1. `cd nixos-dev`
1. `sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode disko`
1. `sudo nixos-install --flake .#dev`

## Bootstrapping wsl

1. `sudo nix run .#nixosConfigurations.wsl.config.system.build.tarballBuilder`
1. `wsl --install --from-file nixos.wsl`
