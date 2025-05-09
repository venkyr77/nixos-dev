{
  inputs,
  pkgs,
  system,
  ...
}: {
  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
    };
    initrd.availableKernelModules = [
      "ahci"
      "nvme"
      "sd_mod"
      "usb_storage"
      "usbhid"
      "xhci_pci"
    ];
    kernelModules = ["kvm-intel"];
  };

  environment.systemPackages = [
    inputs.nfl.packages.${system}.default
    inputs.wezterm.packages.${system}.default
    pkgs.diff-so-fancy
  ];

  hardware = {
    cpu.intel.updateMicrocode = true;
    enableRedistributableFirmware = true;
  };

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

  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
    useDHCP = pkgs.lib.mkDefault true;
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
        "swtch" = "sudo nixos-rebuild switch --flake /home/venky/nixos-dev#default --impure";
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
    settings = {
      KbdInteractiveAuthentication = false;
      PasswordAuthentication = false;
    };
  };

  security.sudo.wheelNeedsPassword = false;

  system.stateVersion = pkgs.lib.mkForce "25.05";

  time.timeZone = "America/Los_Angeles";

  users.users.venky = {
    extraGroups = ["networkmanager" "wheel"];
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFxkVJ1/14ttFbdAYLjLywXBVDpN1496zrZplqvq96bH venkyrocker7777@gmail.com"
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
