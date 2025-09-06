{
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

  networking.hostName = "nixos";

  nix.settings = {
    cores = 1;
    experimental-features = [
      "flakes"
      "nix-command"
      "pipe-operators"
    ];
    max-jobs = 8;
  };

  nixpkgs.config.allowUnfree = true;

  services.openssh.enable = true;

  security.sudo.wheelNeedsPassword = false;

  system.stateVersion = "25.11";

  time.timeZone = "America/Los_Angeles";
}
