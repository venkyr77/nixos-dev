{
  imports = [
    ../../modules/base.nix
  ];

  wsl = {
    defaultUser = "venky";
    enable = true;
  };
}
