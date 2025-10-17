{
  programs.git.lfs = {
    enable = true;
    enablePureSSHTransfer = true;
  };
  home-manager.users.alina.programs.git = {
    enable = true;
    delta.enable = true;
    userName = "alina arielle";
    userEmail = "hi@alina.cx";
    signing.signByDefault = true;
    signing.key = "~/.ssh/id_ed25519.pub";
    extraConfig = {
      gpg.format = "ssh";
      init.defaultBranch = "mistress";
      tag.gpgSign = true;
      tag.sort = "version:refname";
      feature.manyFiles = true;
      column.ui = "auto";
      branch.sort = "-committerdate";
      diff = {
        algorithm = "histogram";
        colorMoved = "plain";
        mnemonicPrefix = true;
        renames = true;
      };
      push = {
        prune = true;
        pruneTags = true;
        all = true;
        autoSetupRemote = true;
      };
      pull.rebase = true;
      #merge.conflictstyle = "zdiff3";
      help.autocorrect = "prompt";
      commit.verbose = true;
      rerere = {
        enabled = true;
        autoupdate = true;
      };
      #core = {
      #excludesfile = "~/.gitignore";
      #fsmonitor = true;
      #untrackedCache = true;
      #};
      rebase = {
        autoSquash = true;
        autoStash = true;
        updateRefs = true;
      };
    };
  };
}
