{pkgs, ...}: {
  users.users.venky = {
    extraGroups = ["networkmanager" "wheel"];
    hashedPassword = "$y$j9T$9cYcKoKnGGu34uPxI9qyA0$lmfn6B8AqlWOBgR3Xrt55Ej3D/J45p4LwxUjpQnPfB9";
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIKq26n2TKyJF/LSKXTjRHlCS1rG4+P/cQkG8dBufDkh venkyrocker7777@gmail.com"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPlTUXrGWkLvAxORPsjc4mCkBNr1jtKJoJh6fNoj8zYj venkyrocker7777@gmail.com"
    ];
    packages = [
      (pkgs.writeShellScriptBin "init-key"
        # sh
        ''
          install -d -m 700 ~/.ssh
          ssh-keygen -t ed25519 -C "venkyrocker7777@gmail.com" -f ~/.ssh/id_ed25519 -N ""
          chmod 600 ~/.ssh/id_ed25519
          chmod 644 ~/.ssh/id_ed25519.pub
        '')
    ];
    shell = pkgs.zsh;
  };
}
