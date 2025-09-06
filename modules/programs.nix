{
  inputs,
  pkgs,
  system,
  ...
}: {
  environment.systemPackages = [
    inputs.nfl.packages.${system}.default
    inputs.wezterm.packages.${system}.default
    pkgs.diff-so-fancy
  ];

  programs = {
    git = {
      enable = true;
      config = [
        {
          user = {
            email = "venkyrocker7777@gmail.com";
            name = "Venkatesan Ravi";
          };
          core.pager = "diff-so-fancy";
          interactive.diffFilter = "diff-so-fancy --patch";
          color = {
            ui = true;
            diff-highlight = {
              oldNormal = "red bold";
              oldHighlight = "red bold 52";
              newNormal = "green bold";
              newHighlight = "green bold 22";
            };
            diff = {
              meta = "11";
              frag = "magenta bold";
              func = "146 bold";
              commit = "yellow bold";
              old = "red bold";
              new = "green bold";
              whitespace = "red reverse";
            };
          };
        }
      ];
    };

    starship = {
      enable = true;
      settings = {
        add_newline = false;
      };
    };

    zsh = {
      enable = true;
      autosuggestions.enable = true;
      shellAliases = {
        "swtch" = "sudo nixos-rebuild switch --flake /home/venky/nixos-dev#default";
      };
      syntaxHighlighting.enable = true;
      interactiveShellInit = ''
        source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
      '';
    };
  };
}
