{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.system};
in
{
  imports = [
    inputs.spicetify-nix.nixosModules.spicetify
  ];
  programs.spicetify = {
    enable = true;
    experimentalFeatures = true;
    enabledCustomApps = with spicePkgs.apps; [
      marketplace
      lyricsPlus
      ({
        name = "extension.js";
        src = pkgs.fetchzip {
          url = "https://github.com/Pithaya/spicetify-apps-dist/archive/refs/heads/dist/better-local-files.zip";
          hash = "sha256-mLTOd7AmoZAVpb9/lps4PQLXEf5rlJI7hbkNFGVbAXE=";
        };
      })
    ];
    enabledExtensions = with spicePkgs.extensions; [
      goToSong
      listPlaylistsWithSong
      copyToClipboard
      showQueueDuration
      history
      betterGenres
      savePlaylists
      playNext
      trashbin
      allOfArtist
      bestMoment
      seekSong
      groupSession
      hidePodcasts
      shuffle
    ];
    theme = spicePkgs.themes.comfy; # hazy starryNight dribbblishDynamic retroBlur omni hazy defaultDynamic comfy
    colorScheme = "Hikari";
    wayland = true;
    #windowManagerPatch = true;
  };
  #users.users.alina.packages = [spicetify];
}
