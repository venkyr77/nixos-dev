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

  i18n = let
    defaultLocale = "en_US.UTF-8";
  in {
    inherit defaultLocale;
    extraLocaleSettings = {
      LC_ADDRESS = defaultLocale;
      LC_IDENTIFICATION = defaultLocale;
      LC_MEASUREMENT = defaultLocale;
      LC_MONETARY = defaultLocale;
      LC_NAME = defaultLocale;
      LC_NUMERIC = defaultLocale;
      LC_PAPER = defaultLocale;
      LC_TELEPHONE = defaultLocale;
      LC_TIME = defaultLocale;
    };
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
    "pipe-operators"
  ];

  nixpkgs = {
    config.allowUnfree = true;
    hostPlatform = {inherit system;};
  };

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

  services.openssh = {
    enable = true;
    hostKeys = [
      {
        comment = "venkyrocker7777@gmail.com";
        openSSHFormat = true;
        path = "/home/venky/ssh_key/id_ed25519";
        type = "ed25519";
      }
    ];
  };

  security.sudo.wheelNeedsPassword = false;

  system.stateVersion = pkgs.lib.mkForce "25.05";

  time.timeZone = "America/Los_Angeles";

  users.users.venky = {
    extraGroups = ["networkmanager" "wheel"];
    hashedPassword = "$6$rounds=100000$81lL0Tq73HWTg9t8$51JWZI39k6odWCSW9Fi3uyyqwNvwp/V283of7mPb3FfUePdK3Ncwr6L1cWApaI.NyuMQMh7cQjIp2M6J.V36X1";
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
      "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBFqaNY0wqJtkw9KD48iz8yNpueoHY90Tt1zAHa5Nal1YYqYsA4kyVjCF9ZM/MZYcJpCBsXoK8euJWhplqqhgAZo= venkyrocker7777@gmail.com"
    ];
    packages = [
      (pkgs.writeShellScriptBin "init-key"
        # sh
        ''
          mkdir -p /home/venky/.ssh
          sudo cp /home/venky/ssh_key/id_ed25519 /home/venky/.ssh
          sudo cp /home/venky/ssh_key/id_ed25519.pub /home/venky/.ssh
          sudo chmod 755 /home/venky/.ssh
          sudo chmod 755 /home/venky/.ssh/id_ed25519
          sudo chmod 755 /home/venky/.ssh/id_ed25519.pub
        '')
    ];
    shell = pkgs.zsh;
  };
}
