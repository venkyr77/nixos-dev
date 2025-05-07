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

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
    "pipe-operators"
  ];

  nixpkgs.config.allowUnfree = true;

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
      syntaxHighlighting.enable = true;
      interactiveShellInit = ''
        source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
      '';
    };
  };

  services.openssh = {
    enable = true;
    hostKeys = [
      {
        comment = "venkyrocker7777@gmail.com";
        openSSHFormat = true;
        path = "/home/nixos/ssh_key/id_ed25519";
        type = "ed25519";
      }
    ];
    settings = {
      KbdInteractiveAuthentication = false;
      PasswordAuthentication = false;
    };
  };

  users.users.nixos = {
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFxkVJ1/14ttFbdAYLjLywXBVDpN1496zrZplqvq96bH venkyrocker7777@gmail.com"
    ];
    packages = [
      (pkgs.writeShellScriptBin "init-key"
        # sh
        ''
          mkdir -p /home/nixos/.ssh
          cp -r /home/nixos/ssh_key /home/nixos/.ssh
          eval `ssh-agent -s`
          ssh-add /home/nixos/.ssh/id_ed25519.pub
        '')
    ];
    shell = pkgs.zsh;
  };

  system.stateVersion = "25.05";

  wsl.enable = true;
}
