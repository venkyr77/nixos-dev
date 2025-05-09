# nixos-dev
Personal nixos system for development

```
sudo nix-shell -p git --run "git clone https://github.com/venkyr77/nixos-dev.git /etc/nixos/nixos-dev"

sudo nixos-rebuild switch --flake /etc/nixos/nixos-dev#default --impure
```
