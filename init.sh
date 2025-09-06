sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode disko ./modules/disko.nix
sudo nixos-install --max-jobs 4 --cores 2 --flake .# 
